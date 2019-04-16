# VETA
## a MATLAB-based toolbox that provides simultaneous EMG data collection and visualization as well as streamlined offline processing that is designed specifically for use with TMS.

## Workflow

![Workflow](https://raw.githubusercontent.com/greenhouselab/Veta/master/figures/Fig1_veta.tif)

### Main Functions
	
#### recordEMG- visualizes and collects EMG data
helper functions:
	**setOffset** calculates electrode voltage offset for each channel
	**EMGfigure** creates and refreshes figure for data visualization
	**addchannels** adds user-specified number of EMG channels 
	**pulldata** extracts data after every EMG sweep
#### findEMG - identifies MEP and EMG burst events
#### visualizeEMG - GUI that visualizes data with found events

Data can be collected with **recordEMG** or generated by other data acquistion software. **conversion_tools** can be used in the latter case. **findEMG** identifies MEP and EMG burst events. Interactive data review is performed with **visualizeEMG**, which uniquely allows the user to manually correct misidentified events.

## visualize EMG example

![GUI](https://raw.githubusercontent.com/greenhouselab/Veta/master/figures/Fig3_veta.jpg)

Buttons on the left allow the user to both correct MEP and EMG events and clear misidentified events. Metrics that correspond to identified events are displayed on the right.
## Extras

**example_task** provides an example of how to integrate **recordEMG** into task presentation code
**data** provides various kind of example data that were collected, processed, and visualized using this toolbox


