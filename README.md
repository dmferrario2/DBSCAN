# DBSCAN for multi-hazard spatio-temporal footprint analysis

_A computational workflow to detect and analyze compound climate hazards (heatwaves, drought, wind, precipitation) using spatial-temporal clustering._

### **📜 Overview**
This repository provides a methodology to identify multi-hazard footprints by combining climate thresholds, DBSCAN clustering, and spatiotemporal overlap analysis. The workflow consists of three steps:

- **Threshold Identification**: Preprocessing climate data to define hazard-specific thresholds.

- **Single-Hazard Clustering**: Using DBSCAN to detect spatial-temporal clusters for individual hazards.

- **Multi-Hazard Footprints**: Detecting overlaps between single-hazard clusters to identify compound events.

The tool is demonstrated for the Veneto Region (Italy) using 5 years of data (2018–2022) but can be adapted to other regions/timeframes.

### **🛠️ Workflow Steps**
**1. Threshold Identification (Preprocessing)**

**Input**: Gridded climate data (NetCDF format).

**Tools**:

- cdo (Climate Data Operators) for threshold calculations (e.g., percentiles).
- Python scripts for drought indices (e.g., SPI-12) and duration filtering.

**Output**: Binary mask files (NetCDF) indicating hazard exceedance.

**2. Single-Hazard Clustering (Jupyter Notebook)**

**Input**: Daily gridded climate data, binary mask files for each hazard

**Tools**: DBSCAN clustering with custom spatial-temporal weights.

**Hazards Supported**:

- Heatwaves (T_2M > 0°C)
- Drought (SPI_12 < -2)
- Extreme wind (WIND_SPEED > 13.9 m/s)
- Extreme precipitation (TOT_PREC > 20 mm/day).

**Output**: Cluster labels, duration, intensity, and spatial extent per hazard.

**3. Multi-Hazard Footprints (Juputer Notebook)**

**Input**: Single hazard clusters, boundaries and landscape files for Veneto Region

**Tools**: Overlapping single-hazard clusters in space/time (e.g., heatwaves + drought).

**Output**: Compound event statistics (mean/max intensity, duration), visualizations (3D plots, maps).

### **🚀 Quick Start**

1. Install Dependencies:
_bash
pip install numpy pandas xarray geopandas matplotlib scikit-learn cartopy rasterio rioxarray_

2. Download Input Data:
Preprocessed data (2018–2022) is available on Zenodo: https://zenodo.org/........

3. Run the Notebook:
_bash
jupyter notebook multi_hazard_footprints.ipynb_

### Notes:
In order to run the jupyter notebook it is necessary to download the preprocessed data (daily climate data and mask netcdf files) for each hazard, which are available on Zenodo. The data is provided only for testing purposes: to produce consistent results at least 30 years of climate data are required. The publication describing the analysis carried out for the veneto Region on the historical (1991-2022), RCP 4.5, RCP 8.5 (2023-2070) scenarios is in preparation.

### Acknowledgments:
This study was carried out within the frame of Myriad_EU project (https://www.myriadproject.eu/), which has received fundings from the European Union’s Horizon 2020 research and innovation programme call H2020-LC-CLA-2018-2019-2020 under grant agreement number 101003276.

### **📖 Citation**
_@software{MultiHazardFootprint_DBSCAN,

author = {Davide Mauro Ferrario, Timothy Tiggeloven, Margherita Maraschini, Marcello Sanò, Judith Claassen, Marleen de Ruiter, Silvia Torresan, Andrea Critto},

title = {Multi-Hazard Footprints Identification},

year = {2025},

publisher = {Zenodo},

version = {v1.0},

doi = {...../zenodo......},

url = {https://github.com/dmferrario2/DBSCAN}
}_
