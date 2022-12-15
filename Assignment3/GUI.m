function varargout = GUI(varargin)
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @GUI_OpeningFcn, ...
                       'gui_OutputFcn',  @GUI_OutputFcn, ...
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

    function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to GUI (see VARARGIN)

    % Choose default command line output for GUI
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % Load init images at start
    axes(handles.img1)
    origin = imread('start.jpg');
    imshow(origin);

    axes(handles.img2)
    imshow(origin);

    axes(handles.img3)
    imshow(origin);

    axes(handles.img4)
    imshow(origin);

    axes(handles.img5)
    imshow(origin);

    axes(handles.img6)
    imshow(origin);

    axes(handles.img7)
    imshow(origin);

    axis off
    axis image
    % UIWAIT makes GUI wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


    % --- Outputs from this function are returned to the command line.
    function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;


    % --- Executes on button press in pushbutton1.
    function pushbutton1_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get the test image
    [file, path] = uigetfile('*.bmp');
    axes(handles.img1)
    [im, map] = imread(strcat(path, file));
    origin = rgb2gray(ind2rgb(im, map));
    imshow(origin);
    
    % Run eigenFace algorithm    
    order = eigenface(origin);
    
    if order == 0
        origin = imread('no_person_found.png');
        axes(handles.img2)
        imshow(origin);

        axes(handles.img3)
        imshow(origin);

        axes(handles.img4)
        imshow(origin);

        axes(handles.img5)
        imshow(origin);

        axes(handles.img6)
        imshow(origin);

        axes(handles.img7)
        imshow(origin);

        axis off
        axis image
        return
    end
    
    % Update matched images
    axes(handles.img2)
    [im, map] = imread(sprintf('Faces/eig/%da.bmp', order(1)));
    origin = rgb2gray(ind2rgb(im, map));
    imshow(origin);

    axes(handles.img3)
    [im, map] = imread(sprintf('Faces/eig/%da.bmp', order(2)));
    origin = rgb2gray(ind2rgb(im, map));
    imshow(origin);

    axes(handles.img4)
    [im, map] = imread(sprintf('Faces/eig/%da.bmp', order(3)));
    origin = rgb2gray(ind2rgb(im, map));
    imshow(origin);

    axes(handles.img5)
    [im, map] = imread(sprintf('Faces/eig/%da.bmp', order(4)));
    origin = rgb2gray(ind2rgb(im, map));
    imshow(origin);

    axes(handles.img6)
    [im, map] = imread(sprintf('Faces/eig/%da.bmp', order(5)));
    origin = rgb2gray(ind2rgb(im, map));
    imshow(origin);

    axes(handles.img7)
    [im, map] = imread(sprintf('Faces/eig/%da.bmp', order(6)));
    origin = rgb2gray(ind2rgb(im, map));
    imshow(origin);

    axis off
    axis image

    % Update the text info for each updated images    
    handles.text1.String = sprintf('%da.bmp (1)', order(1));
    handles.text2.String = sprintf('%da.bmp (2)', order(2));
    handles.text3.String = sprintf('%da.bmp (3)', order(3));
    handles.text4.String = sprintf('%da.bmp (4)', order(4));
    handles.text5.String = sprintf('%da.bmp (5)', order(5));
    handles.text6.String = sprintf('%da.bmp (6)', order(6));

    % --- Executes during object creation, after setting all properties.
    function edit1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


    % --- Executes during object creation, after setting all properties.
    function edit2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0, ...
        'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    % --- Executes during object creation, after setting all properties.
    function edit3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0, ...
        'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



    % --- Executes during object creation, after setting all properties.
    function text1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to text1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0, ...
        'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    % --- Executes during object creation, after setting all properties.
    function text2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to text2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0, ...
        'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    % --- Executes during object creation, after setting all properties.
    function text3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to text3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0, ...
        'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    % --- Executes during object creation, after setting all properties.
    function text4_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to text4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0, ...
        'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

    % --- Executes during object creation, after setting all properties.
    function text5_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to text5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0, ...
        'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


    % --- Executes during object creation, after setting all properties.
    function text6_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to text6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0, ...
        'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
end
