# DBSCAN for multi-hazard spatio-temporal footprint analysis

_A computational workflow to detect and analyse multi-hazard events (heatwaves, drought, wind, precipitation) using spatial-temporal clustering._

### **📜 Overview**
This repository provides a methodology to identify multi-hazard footprints by combining climate thresholds, DBSCAN clustering, and spatiotemporal overlap analysis. The workflow consists of three steps:

- **Threshold Identification**: Preprocessing climate data to define hazard-specific thresholds.

- **Single-Hazard Clustering**: Using DBSCAN to detect spatial-temporal clusters for individual hazards.

- **Multi-Hazard Footprints**: Detecting overlaps between single-hazard clusters to identify compound and consecutive events.

The tool is demonstrated for the Veneto Region (Italy) using 5 years of data (2018–2022) but can be adapted to other regions/timeframes.

### **🛠️ Workflow Steps**
**1. Threshold computation (Preprocessing)**


**Input**: Gridded climate data (NetCDF format).

**Tools**:

- cdo (Climate Data Operators) for threshold calculations (e.g., percentiles for precipitation, wind, temperature):  1a_hazard_thresholds.sh
- Python scripts for drought indices (e.g., SPI-12) and duration-based filtering of events: 1b_length_check_drought_heat.ipynb

**Output**: Binary mask files (NetCDF) indicating hazard exceedance.

**Hazard Supported**:
- Heat anomaly, from mean daily temperature (T_mean), thresholds defined as: T_mean > 95th calendar day-percentile over a 30 year period (1990-2020), >0 ºC, exceedance lasts for more than 3 days.
- Drought, from daily SPI (Pearson distribution, 1991-2020 calibration period, SPI_12 < -2).
- Extreme wind, from maximum daily wind speed (WIND_SPEED), thresholds defined as: WIND_SPEED >99th spatial percentile over a 30 year period (1990-2020),  WIND_SPEED > 13.9 m/s.
- Extreme precipitation, from daily total precipitation (TOT_PREC), threshold defined as: TOT PREC > 99th spatial percentile over a 30 year period (1990-2020), TOT_PREC > 20 mm/day.

**Notes**:
The CDO code works on lists of input files provided as plain text files (temp_list.txt, prec_list.txt, wind_list.txt), each containing one file path per line. To adapt the code to a different reference period, change the year range in -yearsel,1990/2020 accordingly. To adjust the percentile thresholds, modify the values in -ydrunpctl (temperature) or -timpctl (precipitation, wind). The running window for the day-of-year percentile (currently 15 days) can be changed by editing the integer argument in -ydrunpctl,90,15 and the corresponding -ydrunmin,15 / -ydrunmax,15 calls.

**2. Single-Hazard Clustering - calibration (Jupyter Notebook)**

**Input**: The notebook expects two NetCDF files per hazard: the gridded climate variable (e.g. T_2M, TOT_PREC) and the corresponding binary mask file produced by step 1. File paths and variable names are passed directly to the load_dataset() function.

**Tools**: DBSCAN clustering with custom spatial-temporal weights.

**Output**: Cluster labels, duration, intensity, and spatial extent per hazard.

**Notes**:
The key parameters to adjust for each hazard are passed to single_hazard_cluster():
- day_weight: controls the relative weight of the temporal dimension versus the spatial dimensions in the DBSCAN distance metric — increase it to make the clustering more sensitive to time separation
- epsilon and min_elements: the core DBSCAN parameters (neighbourhood radius and minimum cluster size). A first estimate of epsilon can be obtained via the k-distance elbow method (compute_k_distance()), which plots the sorted distance to the k-th nearest neighbour — the elbow of the curve indicates a natural scale for the neighbourhood radius. The notebook then refines this through an automated parameter sweep (dbscan_sweep_dbionly), which evaluates all combinations of epsilon and min_samples over a user-defined grid and selects the combination minimising the Davies-Bouldin Index (DBI).
- The noise percentage (fraction of points labelled as outliers by DBSCAN) is tracked alongside DBI and visualised jointly via a bivariate colormap — a good parameter set should achieve low DBI without excessive noise, and the bivariate plot makes this trade-off explicit.
- The spatial merging step (merging_clusters, delta=0) merges clusters occurring on the same day; for applications over larger domains than Veneto, this should be reviewed or disabled to preserve spatially co-occurring but distinct events.



**3. Single-Hazard Clustering (Jupyter Notebook)**

**Input**: Daily gridded climate data, binary mask files for each hazard

**Tools**: DBSCAN clustering with custom spatial-temporal weights.

**Output**: Cluster labels, duration, intensity, and spatial extent per hazard.



**4. Single-Hazard Clustering - validation (Jupyter Notebook)**

**Input**: Input format: The notebook requires two types of inputs: (1) cluster output CSV files from the previous step (one per hazard, e.g. 99_YES_F_clust_clean_veneto_only.csv), containing gridded event points with columns for lon, lat, date/time, and a binary event flag; (2) observational validation data — for precipitation and wind, an ESWD event matrix (ESWD_events_matrix_date_province.csv); for heat and drought, province-level monthly presence matrices provided as Excel files. A province shapefile is also required for the spatial join.

**Tools**: Jupyter notebook to check spatial and temporal validation of single hazrad footprints within Veneto Region

**Output**: Validation results of single hazard footprints

**Notes**:
The main parameters to adjust are: 
- year_range: the validation period, currently set to 2018–2022
- window_days: the temporal tolerance when matching model events to observed events — increasing it allows for a looser day-level match between model output and observations
- presence_rule (any_pixel): defines how model presence is aggregated at province level; can be adjusted depending on how strict the spatial match should be
- province_col_shp / province_name_col: must match the actual field name in the shapefile used for the spatial join — this is the most common source of errors when adapting the code to a different domain or shapefile
- To apply the validation to a different region, update the PROV_CODE_MAP dictionary and replace the shapefile accordingly


**5. Multi-Hazard Footprints (Juputer Notebook)**

**Input**: The notebook reads NetCDF files for each hazard from the INPUT_data/ directory, expecting two files per hazard: a mask file (hazard_name_mask.nc) and a data file (hazard_name_data.nc). A regional shapefile is also required for spatial filtering and map plotting (e.g. the Veneto boundary and province shapefiles under INPUT_data/Limiti/ and INPUT_data/boundaries/). For consecutive event analysis, the output of the single-hazard clustering step (cluster CSV files) is used as input.

**Tools**: Overlapping single-hazard clusters in space/time (e.g., heatwaves + drought).

**Output**: Compound and consecutive footprints

**Notes**:
The compound footprint and statistics plots are illustrative on short reanalysis periods — robust results require at least 30 years of data, as noted in the code comments

- DBSCAN parameters (day_weight, epsilon, min_elements) are set per hazard in the single_hazard_cluster() calls and should reflect the calibrated values from the previous step
- time_lag: the maximum number of days allowed between two hazard events to consider them consecutive — currently set to 7 days (consecutive_hazards(..., 7)); increase it to capture more loosely coupled compound events
- option (_YES_F_ / _NO_F_): controls whether an additional empirical filter is applied on top of the threshold mask; set to _NO_F_ to disable it
- start_date / end_date: passed to the 3D visualisation functions to restrict plots to a specific period, useful for inspecting individual events
- presence_rule for compound event flattening: defines how co-occurring single-hazard clusters are combined into compound event labels — all six pairwise combinations (and higher-order overlaps) are handled automatically by compound_events_creation()
- The filter_veneto() function spatially subsets results to the study region; replace the shapefile path to apply the analysis to a different domain


**6. MK-Trends (Jupyter Notebook)**

**Input**: The notebook takes cluster CSV files as input (one per hazard and scenario), expected in the OUTPUT/ directory following the naming convention used in the previous steps (e.g. 99_YES_F_clust_v2.csv). For multi-hazard trend analysis, pre-computed compound event CSV files are required (e.g. consecutive_events_tl3_85_full.csv), containing yearly co-occurrence counts for each hazard pair. The intensity column used per hazard is defined in the hazard_intensity_col dictionary at the top of the notebook and should be updated if variable names differ.

**Tools**: Mann Kendall tests for yearly time series

**Output**: MK results for each hazard pair and scenario are saved as individual CSVs and then concatenated into a single trends_multi_hazard_pairs.csv summary table

**Notes**:
- intensity_stat: controls how cluster intensity is aggregated — mean, median, or max — and can be adjusted in compute_cluster_intensity()
alpha_acf_trigger: the lag-1 autocorrelation threshold above which the notebook automatically switches from the standard Mann-Kendall test to the Hamed-Rao modified version, which accounts for serial autocorrelation in the series; the default is 0.2
- use_log_if_positive: if set to True, the MK test and Sen's slope are computed on the log-transformed series, which is more appropriate for exponentially growing trends
- ci_method: confidence intervals on Sen's slope are estimated via bootstrap (2000 iterations by default); the number of iterations can be adjusted in bootstrap_sen_CI()
- year_range and color_choice: passed directly to plot_mh_trends_mk_rao_bootstrap() for each hazard pair — update these to match the scenario period and preferred plot styling



### **🚀 Quick Start**

1. Install Dependencies:
_bash
pip install numpy pandas xarray geopandas matplotlib scikit-learn cartopy rasterio rioxarray climate_indices_

2. Download Input Data:
Preprocessed data (daily climate netcdf and corresponding binary mask files for 2018–2022) is available on Zenodo: [10.5281/zenodo.15805129](https://zenodo.org/records/15805130)
Regional boundaries and landscapes types are available on GitHub
Original climate data can be freely downloaded:
- [CMCC VHR REA over Italy](https://doi.org/10.25424/cmcc/era5-2km_italy), [Raffa et al., 2021](https://doi.org/10.3390/data6080088), [Adinolfi et al., 2023](https://doi.org/10.1007/s00382-023-06803-w)
- [CMCC VHR PRO over Italy (RCP4.5, RCP 8.5)](https://doi.org/10.25424/CMCC-J90A-5P12), [Raffa et al., 2023](https://doi.org/10.1038/s41597-023-02144-9)


### Notes:
In order to run the jupyter notebook it is necessary to download the preprocessed data (daily climate data and mask netcdf files) for each hazard, which are available on Zenodo. The data is provided only for testing purposes: in order to produce consistent results at least 30 years of climate data are required. The publication describing the analyses carried out in the Veneto Region on the historical (1991-2022), and future scenarios (RCP 4.5, RCP 8.5, 2023-2070) is in preparation. You can find the preprint at: https://doi.org/10.22541/essoar.175396232.24844978/v1

### Acknowledgments:
This study was carried out within the frame of Myriad_EU project (https://www.myriadproject.eu/), which has received fundings from the European Union’s Horizon 2020 research and innovation programme call H2020-LC-CLA-2018-2019-2020 under grant agreement number 101003276.
