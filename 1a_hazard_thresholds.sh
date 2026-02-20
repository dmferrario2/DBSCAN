#!/bin/bash
file_read="temp_list.txt"
if [ -f "$file_read" ]; then
	while IFS= read -r line; do
		file_input="$line"
		echo $file_input
		file_90=${file_input/.nc/_90_thrs.nc}
		file_95=${file_input/.nc/_95_thrs.nc}
		file_99=${file_input/.nc/_99_thrs.nc}
		file_90_mask=${file_input/.nc/_90_mask.nc}
		file_95_mask=${file_input/.nc/_95_mask.nc}
		file_99_mask=${file_input/.nc/_99_mask.nc}
		cdo -ydrunpctl,90,15 $file_input -ydrunmin,15 $file_input -ydrunmax,15 $file_input $file_90
		cdo -ydrunpctl,95,15 $file_input -ydrunmin,15 $file_input -ydrunmax,15 $file_input $file_95
		cdo -ydrunpctl,99,15 $file_input -ydrunmin,15 $file_input -ydrunmax,15 $file_input $file_99
		cdo -gec,0 -ydaysub $file_input $file_90 $file_90_mask
		cdo -gec,0 -ydaysub $file_input $file_95 $file_95_mask
		cdo -gec,0 -ydaysub $file_input $file_99 $file_99_mask
	done < $file_read
else
	echo "file does not exists"

file_read="prec_list.txt"
if [ -f "$file_read" ]; then
	while IFS= read -r line; do
		file_input="$line"
		echo $file_input
		file_90=${file_input/.nc/_90_thrs.nc}
		file_95=${file_input/.nc/_95_thrs.nc}
		file_99=${file_input/.nc/_99_thrs.nc}
		file_90_mask=${file_input/.nc/_90_mask.nc}
		file_95_mask=${file_input/.nc/_95_mask.nc}
		file_99_mask=${file_input/.nc/_99_mask.nc}
		cdo -timpctl,90 $file_input -timmin $file_input -timmax $file_input $file_90
		cdo -timpctl,95 $file_input -timmin $file_input -timmax $file_input $file_95
		cdo -timpctl,99 $file_input -timmin $file_input -timmax $file_input $file_99
		cdo -gec,0 -sub $file_input $file_90 $file_90_mask
		cdo -gec,0 -sub $file_input $file_95 $file_95_mask
		cdo -gec,0 -sub $file_input $file_99 $file_99_mask
	done < $file_read
else
	echo "file does not exists"

file_read="wind_list.txt"
if [ -f "$file_read" ]; then
	while IFS= read -r line; do
		file_input="$line"
		echo $file_input
		file_90=${file_input/.nc/_90_thrs.nc}
		file_95=${file_input/.nc/_95_thrs.nc}
		file_99=${file_input/.nc/_99_thrs.nc}
		file_90_mask=${file_input/.nc/_90_mask.nc}
		file_95_mask=${file_input/.nc/_95_mask.nc}
		file_99_mask=${file_input/.nc/_99_mask.nc}
		cdo -timpctl,90 $file_input -timmin $file_input -timmax $file_input $file_90
		cdo -timpctl,95 $file_input -timmin $file_input -timmax $file_input $file_95
		cdo -timpctl,99 $file_input -timmin $file_input -timmax $file_input $file_99
		cdo -gec,0 -sub $file_input $file_90 $file_90_mask
		cdo -gec,0 -sub $file_input $file_95 $file_95_mask
		cdo -gec,0 -sub $file_input $file_99 $file_99_mask
	done < $file_read
else
	echo "file does not exists"
fi
