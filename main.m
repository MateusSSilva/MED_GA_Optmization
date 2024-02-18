addpath('Src');                 % adding function path

GA_validation()                 % Performs optimization through GA using Flash & Hogan boundary conditions on acceleration {(0,0,0), (D,0,0)}
GA_model()                      % Performs optimization through GA without boundary conditions on the acceleration {(0,0), (D,0)}

% Before run "corrDataModel()", download the data using the link below and
% insert the files in the "Data" folder after extracting the .zip file
% link: https://physionet.org/content/culm/1.0.0/S03/

corrDataModel()                 % running correlation between model and data
