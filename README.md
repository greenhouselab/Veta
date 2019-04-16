#Veta: a MATLAB-based toolbox that provides simultaneous EMG data collection and visualization as well as streamlined offline processing that is designed specifically for use with TMS.

##Workflow

![Workflow](https://raw.githubusercontent.com/greenhouselab/Veta/master/figures/Fig1_veta.tif)

###Main Functions
	
####recordEMG- visualizes and collects EMG data
		calls:
		setOffset-calculates electrode voltage offset for each channel
		EMGfigure-creates and refreshes figure for data visualization
		addchannels-adds user-specified number of EMG channels 
		pulldata- extracts data every sweep
	####findEMG - identifies MEP and EMG burst events
	####visualizeEMG - GUI that visualizes data with found events

##visualize EMG example

![GUI](https://raw.githubusercontent.com/greenhouselab/Veta/master/figures/Fig3_veta.jpg)



