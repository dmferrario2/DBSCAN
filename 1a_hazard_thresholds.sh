#!/bin/bash
file_temp_read="temp_list.txt"
if [ -f "$file_temp_read" ]; then
	while IFS= read -r line; do
		file_temp_input="$line"
		echo $file_temp_input
		file_temp_ref=${file_temp_input/.nc/_ref.nc}
		file_temp_90=${file_temp_input/.nc/_90_thrs.nc}
		file_temp_95=${file_temp_input/.nc/_95_thrs.nc}
		file_temp_99=${file_temp_input/.nc/_99_thrs.nc}
		file_temp_90_mask=${file_temp_input/.nc/_90_mask.nc}
		file_temp_95_mask=${file_temp_input/.nc/_95_mask.nc}
		file_temp_99_mask=${file_temp_input/.nc/_99_mask.nc}
		cdo -yearsel,1990/2020 $file_temp_input $file_temp_ref
		cdo -ydrunpctl,90,15 $file_temp_ref -ydrunmin,15 $file_temp_ref -ydrunmax,15 $file_temp_ref $file_temp_90
		cdo -ydrunpctl,95,15 $file_temp_ref -ydrunmin,15 $file_temp_ref -ydrunmax,15 $file_temp_ref $file_temp_95
		cdo -ydrunpctl,99,15 $file_temp_ref -ydrunmin,15 $file_temp_ref -ydrunmax,15 $file_temp_ref $file_temp_99
		cdo -gec,0 -ydaysub $file_temp_input $file_temp_90 $file_temp_90_mask
		cdo -gec,0 -ydaysub $file_temp_input $file_temp_95 $file_temp_95_mask
		cdo -gec,0 -ydaysub $file_temp_input $file_temp_99 $file_temp_99_mask
	done < $file_temp_read
else
	echo "file does not exists"
fi

file_prec_read="prec_list.txt"
if [ -f "$file_prec_read" ]; then
	while IFS= read -r line; do
		file_prec_input="$line"
		echo $file_prec_input
		file_prec_ref=${file_prec_input/.nc/_ref.nc}
		file_prec_90=${file_prec_input/.nc/_90_thrs.nc}
		file_prec_95=${file_prec_input/.nc/_95_thrs.nc}
		file_prec_99=${file_prec_input/.nc/_99_thrs.nc}
		file_prec_90_mask=${file_prec_input/.nc/_90_mask.nc}
		file_prec_95_mask=${file_prec_input/.nc/_95_mask.nc}
		file_prec_99_mask=${file_prec_input/.nc/_99_mask.nc}
		cdo -yearsel,1990/2020 $file_prec_input $file_prec_ref
		cdo -timpctl,90 $file_prec_ref -timmin $file_prec_ref -timmax $file_prec_ref $file_prec_90
		cdo -timpctl,95 $file_prec_ref -timmin $file_prec_ref -timmax $file_prec_ref $file_prec_95
		cdo -timpctl,99 $file_prec_ref -timmin $file_prec_ref -timmax $file_prec_ref $file_prec_99
		cdo -gec,0 -sub $file_prec_input $file_prec_90 $file_prec_90_mask
		cdo -gec,0 -sub $file_prec_input $file_prec_95 $file_prec_95_mask
		cdo -gec,0 -sub $file_prec_input $file_prec_99 $file_prec_99_mask
	done < $file_prec_read
else
	echo "file does not exists"
fi

file_wind_read="wind_list.txt"
if [ -f "$file_wind_read" ]; then
	while IFS= read -r line; do
		file_wind_input="$line"
		echo $file_wind_input
		file_wind_ref=${file_wind_input/.nc/_ref.nc}
		file_wind_90=${file_wind_input/.nc/_90_thrs.nc}
		file_wind_95=${file_wind_input/.nc/_95_thrs.nc}
		file_wind_99=${file_wind_input/.nc/_99_thrs.nc}
		file_wind_90_mask=${file_wind_input/.nc/_90_mask.nc}
		file_wind_95_mask=${file_wind_input/.nc/_95_mask.nc}
		file_wind_99_mask=${file_wind_input/.nc/_99_mask.nc}
		cdo -yearsel,1990/2020 $file_wind_input $file_wind_ref
		cdo -timpctl,90 $file_wind_ref -timmin $file_wind_ref -timmax $file_wind_ref $file_wind_90
		cdo -timpctl,95 $file_wind_ref -timmin $file_wind_ref -timmax $file_wind_ref $file_wind_95
		cdo -timpctl,99 $file_wind_ref -timmin $file_wind_ref -timmax $file_wind_ref $file_wind_99
		cdo -gec,0 -sub $file_wind_input $file_wind_90 $file_wind_90_mask
		cdo -gec,0 -sub $file_wind_input $file_wind_95 $file_wind_95_mask
		cdo -gec,0 -sub $file_wind_input $file_wind_99 $file_wind_99_mask
	done < $file_wind_read
else
	echo "file does not exists"
fi
