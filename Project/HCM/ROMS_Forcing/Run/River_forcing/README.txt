1) generate river discharge data in "River/"
Run make_river_data

2) edit river estuary location and runoff directory
Edit River/River_location.xlsx
Direction:
% 0: west-east direction 
% 1: south-north direction
RiverCase:
% 1: west to east .or. south to north   direction
% 2: east to west .or. north to south   direction      

3) generate river discharge file "river.mat"
Run make_river_discharge

4) make river forcing file "Riv.nc"
Run make_river_forcing


(%) add dye forcing in river forcing file
Run make_river_dye


(%) add bio forcing in river forcing file
1) generate river Bio data
Run make_river_bio_data
2) edit river Bio variable concentration
Edit files in "River/River_BIO"
3) add Bio forcing in river forcing file
Run make_river_bio_forcing
