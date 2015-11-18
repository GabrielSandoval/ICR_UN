function varargout = TrainGUI(varargin)
% TRAINGUI MATLAB code for TrainGUI.fig
%      TRAINGUI, by itself, creates a new TRAINGUI or raises the existing
%      singleton*.
%
%      H = TRAINGUI returns the handle to a new TRAINGUI or the handle to
%      the existing singleton*.
%
%      TRAINGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAINGUI.M with the given input arguments.
%
%      TRAINGUI('Property','Value',...) creates a new TRAINGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrainGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrainGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrainGUI

% Last Modified by GUIDE v2.5 09-Nov-2015 16:37:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrainGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TrainGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TrainGUI is made visible.
function TrainGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrainGUI (see VARARGIN)

% Choose default command line output for TrainGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrainGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrainGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function letter_corr_Callback(hObject, eventdata, handles)
% hObject    handle to letter_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.correspondence = get(hObject,'String');
guidata(hObject, handles)

% Hints: get(hObject,'String') returns contents of letter_corr as text
%        str2double(get(hObject,'String')) returns contents of letter_corr as a double

% --- Executes during object creation, after setting all properties.
function letter_corr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to letter_corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

% --- Executes on button press in Train.
function [NUM]= Train_Callback(hObject, eventdata, handles)

symbols = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
symbols = [symbols,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];

INPUT_LETTER = handles.correspondence;
LETTER = find(symbols==INPUT_LETTER);
fprintf('\n------------------------------\nExtracting features for "%s:" \n', INPUT_LETTER);
fprintf('\n%s = %d\n------------------------------\n', INPUT_LETTER,LETTER);
images = strcat('./RAW/train/', INPUT_LETTER,'*(*).png');
D = dir(images);
NUM = length(D);

for image_number = 1 : NUM

    image_path = strcat('./RAW/train/',INPUT_LETTER,' (', int2str(image_number),').png');
    
    if exist(image_path) == 0
        fprintf('"%s" does not exist. \n', image_path);
        strcat(image_path, '- DNE')
    else
        character_segment = imread(image_path);
        E = Euler_Number(character_segment);

        input_image = imread(image_path);
        FEATURES69 = Diagonal_Feature_Extraction(input_image);
        FEATURES54 = Vertical_Feature_Extraction(input_image);
       
        fprintf('EULER NUMBER: %d\n', round(E));

        Save_Data_DFE(LETTER, E, FEATURES69);
        Save_Data_VFE(LETTER, E, FEATURES54);
    end
  
end
    
fprintf('Count for "%s": %d.\n', INPUT_LETTER, NUM);
    
% hObject    handle to Train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Update_ANN.
function Update_ANN_Callback(hObject, eventdata, handles)
% hObject    handle to Update_ANN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('\n TRAINING ANN FOR DFE \n');
    Train_DFE_ANN();
fprintf('\n TRAINING ANN FOR VFE \n');
    Train_VFE_ANN();
fprintf('\n TRAINING FINISHED \n');


% --- Executes on button press in extract_all.
function extract_all_Callback(hObject, eventdata, handles)
% hObject    handle to extract_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

symbols = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];

% symbols = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'];

total = 0;

for n = 1: 26
    handles.correspondence = symbols(n); 
    count = Train_Callback(hObject, eventdata, handles);
    total = total + count;
end

fprintf('\nNUMBER OF CHARACTERS ADDED: %d.\n', total);


function Save_Data_DFE(LETTER,E, FEATURES)
    
    load('DATA_DFE.mat');
    
    if(ALL69FE==0)
        ALL69FE=FEATURES;
        save('DATA_DFE.mat','ALL69FE','-append');
    else
        ALL69FE=[ALL69FE;FEATURES];
        save('DATA_DFE.mat','ALL69FE','-append');
    end

    if(ALL69==0)
        ALL69 = zeros(1,52);
        ALL69(LETTER) = 1;
        save('DATA_DFE.mat','ALL69','-append');
    else
        temp_matrix = zeros(1,52);
        temp_matrix(LETTER) = 1;
        ALL69=[ALL69;temp_matrix];
        save('DATA_DFE.mat','ALL69','-append');
    end

    if(E == 1)
        if(NoHole69FE==0)
            NoHole69FE=FEATURES;
            save('DATA_DFE.mat','NoHole69FE','-append');
        else
            NoHole69FE=[NoHole69FE;FEATURES];
            save('DATA_DFE.mat','NoHole69FE','-append');
        end

        if(NoHole69==0)
            NoHole69 = zeros(1,52);
            NoHole69(LETTER) = 1;
            save('DATA_DFE.mat','NoHole69','-append');
        else
            temp_matrix = zeros(1,52);
            temp_matrix(LETTER) = 1;
            NoHole69=[NoHole69;temp_matrix];
            save('DATA_DFE.mat','NoHole69','-append');
        end

    elseif(E == 0)
        if(OneHole69FE==0)
            OneHole69FE=FEATURES;
            save('DATA_DFE.mat','OneHole69FE','-append');
        else
            OneHole69FE=[OneHole69FE;FEATURES];
            save('DATA_DFE.mat','OneHole69FE','-append');
        end

        if(OneHole69==0)
            OneHole69 = zeros(1,52);
            OneHole69(LETTER) = 1;
            save('DATA_DFE.mat','OneHole69','-append');
        else
            temp_matrix = zeros(1,52);
            temp_matrix(LETTER) = 1;
            OneHole69=[OneHole69;temp_matrix];
            save('DATA_DFE.mat','OneHole69','-append');
        end

    elseif(E == -1)
        if(TwoHoles69FE==0)
            TwoHoles69FE=FEATURES;
            save('DATA_DFE.mat','TwoHoles69FE','-append');
        else
             TwoHoles69FE=[TwoHoles69FE;FEATURES];
             save('DATA_DFE.mat','TwoHoles69FE','-append');
        end

        if(TwoHoles69==0)
            TwoHoles69 = zeros(1,52);
            TwoHoles69(LETTER) = 1;
            save('DATA_DFE.mat','TwoHoles69','-append');
        else
            temp_matrix = zeros(1,52);
            temp_matrix(LETTER) = 1;
            TwoHoles69=[TwoHoles69;temp_matrix];
            save('DATA_DFE.mat','TwoHoles69','-append');
        end

    else
         if(Other69FE==0)
            Other69FE=FEATURES;
            save('DATA_DFE.mat','Other69FE','-append');
         else
             Other69FE=[Other69FE;FEATURES];
             save('DATA_DFE.mat','Other69FE','-append');
         end

        if(Other69==0)
            Other69 = zeros(1,52);
            Other69(LETTER) = 1;
            save('DATA_DFE.mat','Other69','-append');
        else
            temp_matrix = zeros(1,52);
            temp_matrix(LETTER) = 1;
            Other69=[Other69;temp_matrix];
            save('DATA_DFE.mat','Other69','-append');
        end
    end

function Save_Data_VFE(LETTER,E, FEATURES)

    load('DATA_VFE.mat');

    if(ALL54FE==0)
        ALL54FE=FEATURES;
        save('DATA_VFE.mat','ALL54FE','-append');
    else
        ALL54FE=[ALL54FE;FEATURES];
        save('DATA_VFE.mat','ALL54FE','-append');
    end

    if(ALL54==0)
        ALL54 = zeros(1,52);
        ALL54(LETTER) = 1;
        save('DATA_VFE.mat','ALL54','-append');
    else
        temp_matrix = zeros(1,52);
        temp_matrix(LETTER) = 1;
        ALL54=[ALL54;temp_matrix];
        save('DATA_VFE.mat','ALL54','-append');

    end

    if(E == 1)
        if(NoHole54FE==0)
            NoHole54FE=FEATURES;
            save('DATA_VFE.mat','NoHole54FE','-append');
        else
            NoHole54FE=[NoHole54FE;FEATURES];
            save('DATA_VFE.mat','NoHole54FE','-append');
        end

        if(NoHole54==0)
            NoHole54 = zeros(1,52);
            NoHole54(LETTER) = 1;
            save('DATA_VFE.mat','NoHole54','-append');
        else
            temp_matrix = zeros(1,52);
            temp_matrix(LETTER) = 1;
            NoHole54=[NoHole54;temp_matrix];
            save('DATA_VFE.mat','NoHole54','-append');
        end

    elseif(E == 0)
        if(OneHole54FE==0)
            OneHole54FE=FEATURES;
            save('DATA_VFE.mat','OneHole54FE','-append');
        else
            OneHole54FE=[OneHole54FE;FEATURES];
            save('DATA_VFE.mat','OneHole54FE','-append');
        end

        if(OneHole54==0)
            OneHole54 = zeros(1,52);
            OneHole54(LETTER) = 1;
            save('DATA_VFE.mat','OneHole54','-append');

        else
            temp_matrix = zeros(1,52);
            temp_matrix(LETTER) = 1;
            OneHole54=[OneHole54;temp_matrix];
            save('DATA_VFE.mat','OneHole54','-append');
        end

    elseif(E == -1)
        if(TwoHoles54FE==0)
            TwoHoles54FE=FEATURES;
            save('DATA_VFE.mat','TwoHoles54FE','-append');
        else
             TwoHoles54FE=[TwoHoles54FE;FEATURES];
             save('DATA_VFE.mat','TwoHoles54FE','-append');
        end

        if(TwoHoles54==0)
            TwoHoles54 = zeros(1,52);
            TwoHoles54(LETTER) = 1;
            save('DATA_VFE.mat','TwoHoles54','-append');
        else
            temp_matrix = zeros(1,52);
            temp_matrix(LETTER) = 1;
            TwoHoles54=[TwoHoles54;temp_matrix];
            save('DATA_VFE.mat','TwoHoles54','-append');
        end

    else
         if(Other54FE==0)
            Other54FE=FEATURES;
            save('DATA_VFE.mat','Other54FE','-append');
         else
             Other54FE=[Other54FE;FEATURES];
             save('DATA_VFE.mat','Other54FE','-append');
         end

        if(Other54==0)
            Other54 = zeros(1,52);
            Other54(LETTER) = 1;
            save('DATA_VFE.mat','Other54','-append');
        else
            temp_matrix = zeros(1,52);
            temp_matrix(LETTER) = 1;
            Other54=[Other54;temp_matrix];
            save('DATA_VFE.mat','Other54','-append');
        end
    end

function Train_DFE_ANN()   
    NETWORK69 = load('NETWORKS_DFE.mat');
    DATA69 = load('DATA_DFE.mat');

    net69 = patternnet(5, 'trainbr');
    net69.trainParam.epochs = 150;

    NETWORK69.netALL69 = net69;
    NETWORK69.netNoHole69 = net69;
    NETWORK69.netOneHole69 = net69;
    NETWORK69.netTwoHole69 = net69;
    NETWORK69.netOtherHole69 = net69;

    tic

    if ~((length(DATA69.ALL69) == 1) && (DATA69.ALL69 == 0))
        fprintf('\nTraining Network: netALL69\n');
        [netALL69]=train(NETWORK69.netALL69,DATA69.ALL69FE',DATA69.ALL69');
        save('NETWORKS_DFE.mat', 'netALL69', '-append');
    end

    if ~((length(DATA69.NoHole69) == 1) && (DATA69.NoHole69 == 0))
        fprintf('\nTraining Network: netNoHole69\n');
        [netNoHole69]=train(NETWORK69.netNoHole69,DATA69.NoHole69FE',DATA69.NoHole69');
        save('NETWORKS_DFE.mat', 'netNoHole69', '-append');
    end

    if ~((length(DATA69.OneHole69) == 1) && (DATA69.OneHole69 == 0))
        fprintf('\nTraining Network: netOneHole69\n');
        [netOneHole69]=train(NETWORK69.netOneHole69,DATA69.OneHole69FE',DATA69.OneHole69');
        save('NETWORKS_DFE.mat', 'netOneHole69', '-append');
    end

    if ~((length(DATA69.TwoHoles69) == 1) && (DATA69.TwoHoles69 == 0))
        fprintf('\nTraining Network: netTwoHole69\n');
        [netTwoHole69]=train(NETWORK69.netTwoHole69,DATA69.TwoHoles69FE',DATA69.TwoHoles69');
        save('NETWORKS_DFE.mat', 'netTwoHole69', '-append');
    end

    if ~((length(DATA69.Other69) == 1) && (DATA69.Other69 == 0))
        fprintf('\nTraining Network: netOtherHole69\n');
        [netOtherHole69]=train(NETWORK69.netOtherHole69,DATA69.Other69FE',DATA69.Other69');
        save('NETWORKS_DFE.mat', 'netOtherHole69', '-append');
    end

    toc
    
 function Train_VFE_ANN()   
    NETWORK54 = load('NETWORKS_VFE.mat');
    DATA54 = load('DATA_VFE.mat');

    net54 = patternnet(5, 'trainbr');
    net54.trainParam.epochs = 150;

    NETWORK54.netALL54 = net54;
    NETWORK54.netNoHole54 = net54;
    NETWORK54.netOneHole54 = net54;
    NETWORK54.netTwoHole54 = net54;
    NETWORK54.netOtherHole54 = net54;

    tic

    if ~((length(DATA54.ALL54) == 1) && (DATA54.ALL54 == 0))
        fprintf('\nTraining Network: netALL54\n');
        [netALL54]=train(NETWORK54.netALL54,DATA54.ALL54FE',DATA54.ALL54');
        save('NETWORKS_VFE.mat', 'netALL54', '-append');
    end

    if ~((length(DATA54.NoHole54) == 1) && (DATA54.NoHole54 == 0))
        fprintf('\nTraining Network: netNoHole54\n');
        [netNoHole54]=train(NETWORK54.netNoHole54,DATA54.NoHole54FE',DATA54.NoHole54');
        save('NETWORKS_VFE.mat', 'netNoHole54', '-append');
    end

    if ~((length(DATA54.OneHole54) == 1) && (DATA54.OneHole54 == 0))
        fprintf('\nTraining Network: netOneHole54\n');
        [netOneHole54]=train(NETWORK54.netOneHole54,DATA54.OneHole54FE',DATA54.OneHole54');
        save('NETWORKS_VFE.mat', 'netOneHole54', '-append');
    end

    if ~((length(DATA54.TwoHoles54) == 1) && (DATA54.TwoHoles54 == 0))
        fprintf('\nTraining Network: netTwoHole54\n');
        [netTwoHole54]=train(NETWORK54.netTwoHole54,DATA54.TwoHoles54FE',DATA54.TwoHoles54');
        save('NETWORKS_VFE.mat', 'netTwoHole54', '-append');
    end

    if ~((length(DATA54.Other54) == 1) && (DATA54.Other54 == 0))
        fprintf('\nTraining Network: netOtherHole54\n');
        [netOtherHole54]=train(NETWORK54.netOtherHole54,DATA54.Other54FE',DATA54.Other54');
        save('NETWORKS_VFE.mat', 'netOtherHole54', '-append');
    end

    toc