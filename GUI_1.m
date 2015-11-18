function varargout = GUI_1(varargin)
% GUI_1 MATLAB code for GUI_1.fig
%      GUI_1, by itself, creates a new GUI_1 or raises the existing
%      singleton*.
%
%      H = GUI_1 returns the handle to a new GUI_1 or the handle to
%      the existing singleton*.
%
%      GUI_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_1.M with the given input arguments.
%
%      GUI_1('Property','Value',...) creates a new GUI_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_1

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_1_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_1_OutputFcn, ...
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


% --- Executes just before GUI_1 is made visible.
function GUI_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_1 (see VARARGIN)

% Choose default command line output for GUI_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_image.
function [file_pwd, file_name, file_extension, path] = load_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('1) LOADING IMAGE \n');

axes(handles.axes1);
x = imgetfile();
[handles.file_pwd,handles.file_name,handles.file_extension, path] = fileparts(x);
%if ~(handles.file_extension == '.png');
%    set(handles.output_display, 'string', 'File format not supported');
    imshow(x);
    file_pwd = handles.file_pwd;
    file_name = handles.file_name;
    file_extension = handles.file_extension;
    handles.path = x;
    path = x;
    guidata(hObject, handles);
%end

% --- Executes on button press in gray_scale_image.
function gray_scale_image_Callback(hObject, eventdata, handles)
% hObject    handle to gray_scale_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('2) CONVERTING TO GRAYSCALE \n');
x = imread(handles.path);
gray_x = rgb2gray(x);
axes(handles.axes1);
imshow(gray_x);

% --- Executes on button press in binary_image.
function binary_image_Callback(hObject, eventdata, handles)
% hObject    handle to binary_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('3) BINARIZATION \n');

gray_x = getimage();

threshold = Otsu(gray_x);
BW = im2bw(gray_x, threshold);
set(handles.output_display, 'string', strcat('THRESHOLD VALUE: ', num2str(threshold)));

input_image = xor(1,BW);
axes(handles.axes1);
imshow(input_image);

%--------------- DISPLAY HISTOGRAM OF BINARY IMAGE -------------

hist_params = Hist_Params(input_image);

[handles.image_height, handles.image_width] = size(input_image);
guidata(hObject, handles);

% --- Executes on button press in skew_correction.
function skew_correction_Callback(hObject, eventdata, handles)
% hObject    handle to skew_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('4) UNDER SKEW DETECTION/CORRECTION \n');

input_image = getimage();

skew_angle = Skew_Correction(input_image);

rotated_image = imrotate(input_image, skew_angle);
imshow(rotated_image);

set(handles.output_display, 'string', strcat('Image Skew Angle: ', num2str(skew_angle)));
hold off;

% --- Executes on button press in slant_correction.
function slant_correction_Callback(hObject, eventdata, handles)
% hObject    handle to slant_correction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('5) DE-SLANTING THE IMAGE \n');

slant_angle = 1;
angles = 0;
angles_ctr = 0;
while (slant_angle > .15)
    input_image = getimage();

    slant_angle = Slant_Correction(input_image);
    angles_ctr = angles_ctr+1;
    angles(angles_ctr) = slant_angle;
    
    T = maketform('affine', [1 0 0; slant_angle 1 0; 0 0 1] );
    transformed_image = imtransform(input_image,T, 'FillValues', 0);
    axes(handles.axes1);
    imshow(transformed_image);
end

[max_value, max_index] = max(abs(angles));

set(handles.output_display, 'string', strcat('Image Slant Value: ', num2str(angles(max_index))));


% --- Executes on button press in line_segmentation.
function [number_of_line_segments, line_segmentation_points] = line_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to line_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('6) LINE SEGMENTATION \n');

    input_image = (padarray(getimage(), [5 5], 0));

    [image_height,image_width] = size(input_image);
    [segmentation_points] = Line_Segmentation(input_image);
    axes(handles.axes1);
    imshow(input_image);
    
    for l = 1 : length(segmentation_points)
        line([1,image_width],[segmentation_points(l),segmentation_points(l)]);
    end
    
    number_of_line_segments = floor(length(segmentation_points)/2);
    
    spc = 1;
    for line_number = 1 : number_of_line_segments;
    z = input_image(segmentation_points(spc): segmentation_points(spc+1), 1:image_width);
    imwrite(z, strcat(handles.file_pwd, '\segments\', 'line_', int2str(line_number), '_', handles.file_name, handles.file_extension));
    spc = spc+2;
    end

    set(handles.output_display, 'string', strcat('NUMBER OF LINE SEGMENTS: ', num2str(number_of_line_segments)));
    handles.number_of_line_segments = number_of_line_segments;
    handles.line_segmentation_points = segmentation_points;
    
    guidata(hObject, handles);
    
    line_segmentation_points = segmentation_points;
    number_of_line_segments = number_of_line_segments;

% --- Executes on button press in word_segmentation.
function [number_of_word_segments, word_segmentation_points] = word_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to word_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('7) WORD SEGMENTATION \n');

line_segmentation_points = handles.line_segmentation_points;
line_top = 1;
line_bottom = 2;
total_words = 0;

FILE_PWD = handles.file_pwd;
FILE_NAME = handles.file_name;
FILE_EXTENSION = handles.file_extension;
NUMBER_OF_LINE_SEGMENTS = handles.number_of_line_segments;
NUMBER_OF_WORD_SEGMENTS = 0;

overall_segmentation_point = [];
osp = 1;
for segment_number = 1 : NUMBER_OF_LINE_SEGMENTS
    input_path = strcat(FILE_PWD, '\segments\', 'line_', int2str(segment_number), '_', FILE_NAME, FILE_EXTENSION);
    if exist(input_path) == 0
        break;
    else
        input_image = imread(input_path);
        [segmentation_points] = Word_Segmentation(input_image');

        for w = 1 : length(segmentation_points)
            line([segmentation_points(w), segmentation_points(w)],[line_segmentation_points(line_top),line_segmentation_points(line_bottom)]);
        end
        
        number_of_word_segments = floor(length(segmentation_points)/2);
        NUMBER_OF_WORD_SEGMENTS = NUMBER_OF_WORD_SEGMENTS + number_of_word_segments;

        spc = 1;
        for n = 1 : number_of_word_segments;
            z = input_image(: , segmentation_points(spc): segmentation_points(spc+1));
            imwrite(z, strcat(FILE_PWD, '\segments\', 'line_', int2str(segment_number), '_word_', int2str(n), '_', FILE_NAME, FILE_EXTENSION));
            
            overall_segmentation_point(osp) = segmentation_points(spc);
            osp = osp+1;
            overall_segmentation_point(osp) = segmentation_points(spc+1);
            osp = osp+1;
            
            spc = spc+2;
        end
    end
    
line_top = line_top + 2;
line_bottom = line_bottom + 2;

end

handles.number_of_word_segments = NUMBER_OF_WORD_SEGMENTS;
handles.word_segmentation_points = overall_segmentation_point;
set(handles.output_display, 'string', strcat('NUMBER OF WORD SEGMENTS: ', num2str(NUMBER_OF_WORD_SEGMENTS)));
guidata(hObject, handles);

word_segmentation_points = overall_segmentation_point;
number_of_word_segments = NUMBER_OF_WORD_SEGMENTS;

% --- Executes on button press in character_segmentation.
function [number_of_char_segments, character_segmentation_points, char_distribution] =  character_segmentation_Callback(hObject, eventdata, handles)
% hObject    handle to character_segmentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('8) CHARACTER SEGMENTATION \n');

line_segmentation_points = handles.line_segmentation_points;
word_segmentation_points = handles.word_segmentation_points;

line_top = 1;
line_bottom = 2;
word_left = 1;
word_right = 2;

total_characters = 0;

FILE_PWD = handles.file_pwd;
FILE_NAME = handles.file_name;
FILE_EXTENSION = handles.file_extension;
NUMBER_OF_LINE_SEGMENTS = handles.number_of_line_segments;
NUMBER_OF_WORD_SEGMENTS = handles.number_of_word_segments;
NUMBER_OF_CHARACTER_SEGMENTS = 0;
CHAR_DISTRIBUTION = 0;
dist_ctr = 0;
hold on;

for segment_number = 1 : NUMBER_OF_LINE_SEGMENTS
    
    for word_segment_number = 1 : NUMBER_OF_WORD_SEGMENTS
    
        input_path = strcat(FILE_PWD, '\segments\', 'line_', int2str(segment_number), '_word_', int2str(word_segment_number), '_', FILE_NAME, FILE_EXTENSION);

        if exist(input_path) == 0
            strcat('line_', int2str(segment_number), '_word_', int2str(word_segment_number), '_', FILE_NAME, FILE_EXTENSION, 'does not exist');
            break;
        else
            input_image = imread(input_path);

            [image_height,image_width] = size(input_image);

%             segmentation_points = Character_Segmentation_Modified_Hist(input_image);
%             segmentation_points = Character_Segmentation_Orig(input_image);
            segmentation_points = Character_Segmentation(input_image);
            
            for w = 1 : length(segmentation_points)
                line([word_segmentation_points(word_left)+segmentation_points(w), word_segmentation_points(word_left)+segmentation_points(w)],[line_segmentation_points(line_top),line_segmentation_points(line_bottom)],'Color', 'r');
            end
            
            number_of_char_segments = length(segmentation_points)-1;
            dist_ctr = dist_ctr + 1;
            CHAR_DISTRIBUTION(dist_ctr) = number_of_char_segments;
            NUMBER_OF_CHARACTER_SEGMENTS = NUMBER_OF_CHARACTER_SEGMENTS + number_of_char_segments;

            spc = 1;
            for n = 1 : number_of_char_segments;
                z = input_image(: , segmentation_points(spc): segmentation_points(spc+1));
                imwrite(z, strcat(FILE_PWD, '\segments\', 'line_', int2str(segment_number), '_word_', int2str(word_segment_number), '_char_', int2str(n), '_', FILE_NAME, FILE_EXTENSION));
                imwrite(z, strcat(FILE_PWD, '\train\', 'line_', int2str(segment_number), '_word_', int2str(word_segment_number), '_char_', int2str(n), '_', FILE_NAME, FILE_EXTENSION));
                spc = spc+1;
            end
        
        end
        
        word_left = word_left+2;
        
    end
    
line_top = line_top + 2;
line_bottom = line_bottom + 2;

end

hold off;
handles.number_of_char_segments = NUMBER_OF_CHARACTER_SEGMENTS;
handles.character_segmentation_points = segmentation_points;
handles.char_distribution = CHAR_DISTRIBUTION;
set(handles.output_display, 'string', strcat('NUMBER OF CHARACTER SEGMENTS: ', num2str(NUMBER_OF_CHARACTER_SEGMENTS)));
guidata(hObject, handles);

number_of_char_segments = NUMBER_OF_CHARACTER_SEGMENTS;
char_distribution = CHAR_DISTRIBUTION;
character_segmentation_points = segmentation_points;


% --- Executes on button press in euler_number.
function [euler_numbers] = euler_number_Callback(hObject, eventdata, handles)
% hObject    handle to euler_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('9) CALCULATING EULER NUMBERS \n');

FILE_PWD = handles.file_pwd;
FILE_NAME = handles.file_name;
FILE_EXTENSION = handles.file_extension;

euler_index = 0;

EULER_NUMBERS = 0;
for line_segment_number = 1 : handles.number_of_line_segments
    for word_segment_number = 1 : handles.number_of_word_segments
        for char_segment_number = 1 : handles.number_of_char_segments
            input_path = strcat(FILE_PWD, '\segments\', 'line_', int2str(line_segment_number), '_word_', int2str(word_segment_number), '_char_', int2str(char_segment_number), '_', FILE_NAME, FILE_EXTENSION);
        
            if exist(input_path) == 0
                break;
            else
                character_segment = imread(input_path);
                E = Euler_Number(character_segment);
            end
            
            euler_index = euler_index + 1;
            EULER_NUMBERS(euler_index) = E;
            
        end
    end
end

set(handles.output_display, 'string', strcat(int2str(length(EULER_NUMBERS)), ' Euler Numbers were saved.'));
handles.euler_numbers = EULER_NUMBERS;
guidata(hObject, handles);

euler_numbers = EULER_NUMBERS;


% --- Executes on button press in diagonal_feature_extraction.
function [features] = diagonal_feature_extraction_Callback(hObject, eventdata, handles)
% hObject    handle to diagonal_feature_extraction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('10) EXTRACTING FEATURES \n');

FILE_PWD = handles.file_pwd;
FILE_NAME = handles.file_name;
FILE_EXTENSION = handles.file_extension;
b = get(handles.With_Diagonal_Feature);
word_counter = 0;
total_characters = 0;

for line_segment_number = 1 : handles.number_of_line_segments
    for word_segment_number = 1 : handles.number_of_word_segments
        for char_segment_number = 1 : handles.number_of_char_segments
            input_path = strcat(FILE_PWD, '\segments\', 'line_', int2str(line_segment_number), '_word_', int2str(word_segment_number), '_char_', int2str(char_segment_number), '_', FILE_NAME, FILE_EXTENSION);
                
            if exist(input_path) == 0 
                break;
            else
                input_image = imread(input_path);

                if b.Value
                    A = Diagonal_Feature_Extraction(input_image);
                else
                    A = Vertical_Feature_Extraction(input_image);
                end
             end

            total_characters = total_characters+1;
            FEATURES(total_characters,:) = A;
        end
    end
end

handles.features = FEATURES;
guidata(hObject, handles);

features = FEATURES;


% --- Executes on button press in Classification.
function [output] = Classification_Callback(hObject, eventdata, handles)
% hObject    handle to Classification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fprintf('11) CLASSIFYING CHARACTERS \n');
a = get(handles.With_Euler_Number);
b = get(handles.With_Diagonal_Feature);

FEATURES = handles.features;

if a.Value && b.Value
    output = Classify_Euler_DFE(handles.euler_numbers, FEATURES, handles.number_of_char_segments);
elseif a.Value && ~b.Value
    output = Classify_Euler_VFE(handles.euler_numbers, FEATURES, handles.number_of_char_segments);
elseif ~a.Value && b.Value
    output = Classify_DFE(FEATURES, handles.number_of_char_segments);
elseif ~a.Value && ~b.Value
    output = Classify_VFE(FEATURES, handles.number_of_char_segments);
end

recognition = Recognize(output, handles.char_distribution);
set(handles.output_display, 'string', strcat('OUTPUT: ', recognition));


% --- Executes on button press in Recognize.
function Recognize_Callback(hObject, eventdata, handles)
% hObject    handle to Recognize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.file_pwd,handles.file_name,handles.file_extension, handles.path] = load_image_Callback(hObject, eventdata, handles);
tic

gray_scale_image_Callback(hObject, eventdata, handles);
binary_image_Callback(hObject, eventdata, handles);
% skew_correction_Callback(hObject, eventdata, handles);
slant_correction_Callback(hObject, eventdata, handles);
[handles.number_of_line_segments, handles.line_segmentation_points] = line_segmentation_Callback(hObject, eventdata, handles);
[handles.number_of_word_segments, handles.word_segmentation_points] = word_segmentation_Callback(hObject, eventdata, handles);
[handles.number_of_char_segments, handles.character_segmentation_points, handles.char_distribution] = character_segmentation_Callback(hObject, eventdata, handles);

a = get(handles.With_Euler_Number);
if a.Value
    [handles.euler_numbers] = euler_number_Callback(hObject, eventdata, handles);
end

[handles.features] = diagonal_feature_extraction_Callback(hObject, eventdata, handles);
[handles.output] = Classification_Callback(hObject, eventdata, handles);
recognition = Recognize(handles.output, handles.char_distribution);

set(handles.output_display, 'string', strcat('OUTPUT: ', recognition));
fprintf('OUTPUT: %s \n\n', recognition);

toc
clear

function [output] = Classify_Euler_DFE(EULER_NUMBERS, FEATURES, number_of_char_segments)
    ANN69 = load('NETWORKS_DFE.mat');    
    DATA69 = load('DATA_DFE.mat');
    output = '';
    
    for char_segment_number = 1 : number_of_char_segments 
        if EULER_NUMBERS(char_segment_number) == 1
            if ~((length(DATA69.NoHole69) == 1) && (DATA69.NoHole69 == 0))
                [ann_output_v(char_segment_number, :), char_output(char_segment_number, :)] = max(ANN69.netNoHole69(FEATURES(char_segment_number, :)'));
                annOutput(char_segment_number, :) = ANN69.netNoHole69(FEATURES(char_segment_number, :)');
            else
                ann_output_v(char_segment_number, :) = -1;
                annOutput(char_segment_number, :) = -1;
                char_output(char_segment_number, :) = -1;
            end
        elseif EULER_NUMBERS(char_segment_number) == 0
            if ~((length(DATA69.OneHole69) == 1) && (DATA69.OneHole69 == 0))
                [ann_output_v(char_segment_number, :), char_output(char_segment_number, :)] = max(ANN69.netOneHole69(FEATURES(char_segment_number, :)'));
                annOutput(char_segment_number, :) = ANN69.netOneHole69(FEATURES(char_segment_number, :)');
            else
                ann_output_v(char_segment_number, :) = -1;
                annOutput(char_segment_number, :) = -1;
                char_output(char_segment_number, :) = -1;
            end
        elseif EULER_NUMBERS(char_segment_number) == -1
            if ~((length(DATA69.TwoHoles69) == 1) && (DATA69.TwoHoles69 == 0))
                [ann_output_v(char_segment_number, :), char_output(char_segment_number, :)] = max(ANN69.netTwoHole69(FEATURES(char_segment_number, :)'));
                annOutput(char_segment_number, :) = ANN69.netTwoHole69(FEATURES(char_segment_number, :)');
            else
                ann_output_v(char_segment_number, :) = -1;
                annOutput(char_segment_number, :) = -1;
                char_output(char_segment_number, :) = -1;
            end
        else
            if ~((length(DATA69.Other69) == 1) && (DATA69.Other69 == 0))
                [ann_output_v(char_segment_number, :), char_output(char_segment_number, :)] = max(ANN69.netOtherHole69(FEATURES(char_segment_number, :)'));
                annOutput(char_segment_number, :) = ANN69.netOtherHole69(FEATURES(char_segment_number, :)');
            else
                ann_output_v(char_segment_number, :) = -1;
                annOutput(char_segment_number, :) = -1;
                char_output(char_segment_number, :) = -1;
            end
        end

    end

output = char_output;
annOutput';
ann_output_v;

function [output] = Classify_Euler_VFE(EULER_NUMBERS, FEATURES, number_of_char_segments)
    ANN54 = load('NETWORKS_VFE.mat');    
    DATA54 = load('DATA_VFE.mat');
    output = '';
    
    for char_segment_number = 1 : number_of_char_segments 
        if EULER_NUMBERS(char_segment_number) == 1
            if ~((length(DATA54.NoHole54) == 1) && (DATA54.NoHole54 == 0))
                [ann_output_v(char_segment_number, :), char_output(char_segment_number, :)] = max(ANN54.netNoHole54(FEATURES(char_segment_number, :)'));
                annOutput(char_segment_number, :) = ANN54.netNoHole54(FEATURES(char_segment_number, :)');
            else
                ann_output_v(char_segment_number, :) = -1;
                annOutput(char_segment_number, :) = -1;
                char_output(char_segment_number, :) = -1;
            end
        elseif EULER_NUMBERS(char_segment_number) == 0
            if ~((length(DATA54.OneHole54) == 1) && (DATA54.OneHole54 == 0))
                [ann_output_v(char_segment_number, :), char_output(char_segment_number, :)] = max(ANN54.netOneHole54(FEATURES(char_segment_number, :)'));
                annOutput(char_segment_number, :) = ANN54.netOneHole54(FEATURES(char_segment_number, :)');
            else
                ann_output_v(char_segment_number, :) = -1;
                annOutput(char_segment_number, :) = -1;
                char_output(char_segment_number, :) = -1;
            end
        elseif EULER_NUMBERS(char_segment_number) == -1
            if ~((length(DATA54.TwoHoles54) == 1) && (DATA54.TwoHoles54 == 0))
                [ann_output_v(char_segment_number, :), char_output(char_segment_number, :)] = max(ANN54.netTwoHole54(FEATURES(char_segment_number, :)'));
                annOutput(char_segment_number, :) = ANN54.netTwoHole54(FEATURES(char_segment_number, :)');
            else
                ann_output_v(char_segment_number, :) = -1;
                annOutput(char_segment_number, :) = -1;
                char_output(char_segment_number, :) = -1;
            end
        else
            if ~((length(DATA54.Other54) == 1) && (DATA54.Other54 == 0))
                [ann_output_v(char_segment_number, :), char_output(char_segment_number, :)] = max(ANN54.netOtherHole54(FEATURES(char_segment_number, :)'));
                annOutput(char_segment_number, :) = ANN54.netOtherHole54(FEATURES(char_segment_number, :)');
            else
                ann_output_v(char_segment_number, :) = -1;
                annOutput(char_segment_number, :) = -1;
                char_output(char_segment_number, :) = -1;
            end
        end
    end

output = char_output;
annOutput';
ann_output_v;

function [output] = Classify_DFE(FEATURES, number_of_char_segments)
    ANN69 = load('NETWORKS_DFE.mat');    
    DATA69 = load('DATA_DFE.mat');

    for char_segment_number = 1 : number_of_char_segments 
        if ~((length(DATA69.ALL69) == 1) && (DATA69.ALL69 == 0))
            [ann_output_v(char_segment_number, :), char_output(char_segment_number, :)] = max(ANN69.netALL69(FEATURES(char_segment_number, :)'));
            annOutput(char_segment_number, :) = ANN69.netALL69(FEATURES(char_segment_number, :)');
        else
            ann_output_v(char_segment_number, :) = -1;
            annOutput(char_segment_number, :) = -1;
            char_output(char_segment_number, :) = -1;
        end
    end
    
output = char_output;
annOutput';
ann_output_v;

function [output] = Classify_VFE(FEATURES, number_of_char_segments)
    ANN54 = load('NETWORKS_VFE.mat');    
    DATA54 = load('DATA_VFE.mat');

    for char_segment_number = 1 : number_of_char_segments 
        if ~((length(DATA54.ALL54) == 1) && (DATA54.ALL54 == 0))
            [ann_output_v(char_segment_number, :), char_output(char_segment_number, :)] = max(ANN54.netALL54(FEATURES(char_segment_number, :)'));
            annOutput(char_segment_number, :) = ANN54.netALL54(FEATURES(char_segment_number, :)');
        else
            ann_output_v(char_segment_number, :) = -1;
            annOutput(char_segment_number, :) = -1;
            char_output(char_segment_number, :) = -1;
        end 
    end
    
output = char_output;
annOutput';
ann_output_v;

function [recognition] = Recognize(ann_output, char_distribution)

symbols = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
symbols = [symbols,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];
recognition = '';

for n = 1 : length(ann_output)
        
    char_distribution(1) = char_distribution(1) - 1;
    if round(ann_output(n)) >= 1 && round(ann_output(n)) <= 52
        recognition = [recognition, symbols(round(ann_output(n)))];
    else
        recognition = [recognition, '$'];
    end
    
    if(char_distribution(1) == 0)
        char_distribution(1) = [];
        recognition = [recognition, ' '];
    end

end

% --- Executes on button press in With_Euler_Number.
function With_Euler_Number_Callback(hObject, eventdata, handles)
% hObject    handle to With_Euler_Number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of With_Euler_Number

if get(hObject, 'Value')
    set(handles.With_Euler_Number,'string','With Euler Number','BackgroundColor','w', 'ForegroundColor','black');
    set(handles.euler_number,'enable','on');
else
    set(handles.With_Euler_Number,'string','Without Euler Number','BackgroundColor','black', 'ForegroundColor','w');
    set(handles.euler_number,'enable','off');
end

guidata(hObject, handles);


% --- Executes on button press in With_Diagonal_Feature.
function With_Diagonal_Feature_Callback(hObject, eventdata, handles)
% hObject    handle to With_Diagonal_Feature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of With_Diagonal_Feature

if get(hObject, 'Value')
    set(handles.With_Diagonal_Feature,'string','Diagonal Feature Extraction','BackgroundColor','w', 'ForegroundColor','black');
else
    set(handles.With_Diagonal_Feature,'string','Vertical Feature Extraction','BackgroundColor','black', 'ForegroundColor','w');
end

guidata(hObject, handles);
