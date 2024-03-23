% clc;clear
[sheet_Pin, sheet_Pout, sheet_Min, sheet_Mout] = ...
    deal(1,2,3,4);
filename = 'testdata_t15'; 
%%
Min = xlsread(filename,sheet_Min,'B10:BB10000');
Pin = xlsread(filename,sheet_Pin,'B10:BB10000');
Mout = xlsread(filename,sheet_Mout,'B10:BB10000');
Pout = xlsread(filename,sheet_Pout,'B10:BB10000');

Min_t30  = Min(1:2:end,:);
Mout_t30  = Mout(1:2:end,:);
Pin_t30  = Pin(1:2:end,:);
Pout_t30  = Pout(1:2:end,:);

% Set the filename for t30
filename_t30 = 'testdata_t30.xlsx';

% Write data to the specified sheets in the Excel file
xlswrite(filename_t30, Pin_t30, 1, 'B2');
xlswrite(filename_t30, Pout_t30, 2, 'B2');
xlswrite(filename_t30, Min_t30, 3, 'B2');
xlswrite(filename_t30, Mout_t30, 4, 'B2');

Min_t60  = Min(1:4:end,:);
Mout_t60  = Mout(1:4:end,:);
Pin_t60  = Pin(1:4:end,:);
Pout_t60  = Pout(1:4:end,:);
% Set the filename for t30
filename_t60 = 'testdata_t60.xlsx';

% Write data to the specified sheets in the Excel file
xlswrite(filename_t60, Pin_t60, 1, 'B2');
xlswrite(filename_t60, Pout_t60, 2, 'B2');
xlswrite(filename_t60, Min_t60, 3, 'B2');
xlswrite(filename_t60, Mout_t60, 4, 'B2');
