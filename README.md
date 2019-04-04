<b> Veta: a MATLAB-based toolbox that provides simultaneous EMG data collection and visualization as well as streamlined offline 	processing that is designed specifically for use with TMS.
	
	Main Functions
	
	recordEMG- vizualizes and collects EMG data
		calls:
		setOffset-calculates electrode voltage offset for each channel
		EMGfigure-creates and refreshes figure for data visualization
		addchannels-adds user-specified number of EMG channels 
		pulldata- extracts data every sweep
	findEMG - identifies MEP and EMG burst events
	visualizeEMG - GUI that visualizes data with found events
