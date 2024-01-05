classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        RandomVariableTab               matlab.ui.container.Tab
        MGFtimeupperlimitLabel          matlab.ui.control.Label
                MGFat0Label_2Val                matlab.ui.control.Label
        MGFat0LabelVal                  matlab.ui.control.Label
        MGFat0Label_2                   matlab.ui.control.Label
        MGFat0Label                     matlab.ui.control.Label
        timelim                         matlab.ui.control.NumericEditField
        ExpParam2Label_2                matlab.ui.control.Label
        ExpParam1Label_2                matlab.ui.control.Label
        upperlim                        matlab.ui.control.NumericEditField
        lowerlim                        matlab.ui.control.NumericEditField
        Label_2                         matlab.ui.control.Label
        Label                           matlab.ui.control.Label
        AserOsamaLabel                  matlab.ui.control.Label
        SaifeldenMohamedLabel           matlab.ui.control.Label
        ExperimenttypeDropDown          matlab.ui.control.DropDown
        ExperimenttypeDropDownLabel     matlab.ui.control.Label
        SampleFile                      matlab.ui.control.EditField
        RunRandomVariableButton         matlab.ui.control.Button
        ImportRandomVariableButton      matlab.ui.control.Button
        MeanValueLabel                  matlab.ui.control.Label
        RandomVariableMeanLabel         matlab.ui.control.Label
        ThirdMomentValueLabel           matlab.ui.control.Label
        RandomVariableThirdMomentLabel  matlab.ui.control.Label
        VarianceValueLabel              matlab.ui.control.Label
        RandomVariableVarianceLabel     matlab.ui.control.Label
        RandomVariableLabel             matlab.ui.control.Label
        CIE327ProjectLabel              matlab.ui.control.Label
        InvalidSampleFileWarning        matlab.ui.control.Label
        ExpParam2Label                  matlab.ui.control.Label
        ExpParam1Label                  matlab.ui.control.Label
        ExpParam2                       matlab.ui.control.NumericEditField
        ExpParam1                       matlab.ui.control.NumericEditField
        SecMoment                       matlab.ui.control.UIAxes
        FirMoment                       matlab.ui.control.UIAxes
        mgf                             matlab.ui.control.UIAxes
        RandomProcessTab_2              matlab.ui.container.Tab
        AutoLabel_2                     matlab.ui.control.Label
        autoCorrelationButton_2         matlab.ui.control.Button
        TimeAutocorrelation3DPlotLabel  matlab.ui.control.Label
        PlotNnumberofsamplefunctionsLabel  matlab.ui.control.Label
        WattLabel                       matlab.ui.control.Label
        averagePowerLabel               matlab.ui.control.Label
        TotalAveragePowerLabel          matlab.ui.control.Label
        sampleFunctionsLabel            matlab.ui.control.Label
        LoadButton                      matlab.ui.control.Button
        AutoLabel                       matlab.ui.control.Label
        autoCorrelationButton           matlab.ui.control.Button
        TimeAutocorrelationofnthsamplefunctionLabel  matlab.ui.control.Label
        timeMeanButton                  matlab.ui.control.Button
        timeMeanLabel                   matlab.ui.control.Label
        TimeMeanofnthsamplefunctionLabel_2  matlab.ui.control.Label
        fileInfo                        matlab.ui.control.Label
        LOADPROCESSDATAFILESButton      matlab.ui.control.Button
        Label_4                         matlab.ui.control.Label
        spectralGraph                   matlab.ui.control.UIAxes
        autoGraph                       matlab.ui.control.UIAxes
        ensembleGraph                   matlab.ui.control.UIAxes
        ContextMenu                     matlab.ui.container.ContextMenu
        Menu                            matlab.ui.container.Menu
        Menu2                           matlab.ui.container.Menu
        ContextMenu2                    matlab.ui.container.ContextMenu
        Menu_2                          matlab.ui.container.Menu
        Menu2_2                         matlab.ui.container.Menu
    end


    properties (Access = private)
        MyFilePath % Description
        SampleData % Description
        CanRun = 0
        ExpType = "file" % Description
        RPt
        RPX
        SFM
        SFn
        SFn2
        ensembleMean
        R_x
        FXRV % Description
        N

    end

    methods (Access = private)


        function [] = RunUniform(app)
            a_in = app.ExpParam1.Value;
            b_in = app.ExpParam2.Value;
            u_in = app.upperlim.Value;
            l_in = app.lowerlim.Value;
            if (u_in>l_in)

                if ((a_in < u_in && b_in > l_in))
                    if (l_in > a_in)
                        a = l_in;
                    else

                        a = a_in;
                    end
                    if (u_in < b_in)
                        b = u_in;
                    else
                        b = b_in;

                    end
                    app.InvalidSampleFileWarning.Text = "";
                else
                    a = 0;
                    b = 0;
                end
                mean = (a + b) / 2;
                variance = ((b-a) ^ 2)/12;


                x3_fx = @(x) (1/(b-a)) .* x.^3;
                thirdMoment = integral(x3_fx, a, b);
                app.MeanValueLabel.Text = string(mean);
                app.VarianceValueLabel.Text = string(variance);
                app.ThirdMomentValueLabel.Text = string(thirdMoment);

                mgff = @(t) (exp(t.*b) - exp(t.*a)) ./ (t .* (b - a));
                dmgff = @(t) (((b.*t - 1).*exp(b.*t)) + ((1 - a.*t).*exp(a.*t))) ./ ((b - a).*t.^2);
                ddmgff =  @(t) ((b.^2.*t.^2-2.*b.*t+2).*exp(1).^(b.*t)+(-a.^2.*t.^2+2.*a.*t-2).*exp(1).^(a.*t))./((b-a).*t.^3);

                t = linspace(0, app.timelim.Value, 1000);
                mgfarr = arrayfun(mgff, t);
                dmgffarr = arrayfun(dmgff, t);
                ddmgffarr = arrayfun(ddmgff, t);

                app.MGFat0LabelVal.Text = string((a+b)/2);
                app.MGFat0Label_2Val.Text = string((a^2/3 + (a * b)/3 + b^2/3));

                plot(app.FirMoment, t, dmgffarr);
                plot(app.SecMoment, t, ddmgffarr);
                plot(app.mgf,t, mgfarr);


            else
                a = 0;
                b = 0;
                app.InvalidSampleFileWarning.FontColor = "red";
                app.InvalidSampleFileWarning.Text = "A & B out of range of sample file.";
                            mean = (a + b) / 2;
            variance = ((b-a) ^ 2)/12;
            x3_fx = @(x) (1/(b-a)) .* x.^3;
            thirdMoment = integral(x3_fx, a, b);
            app.MeanValueLabel.Text = string(mean);
            app.VarianceValueLabel.Text = string(variance);
            app.ThirdMomentValueLabel.Text = string(thirdMoment);
            % %
            end
        end

        function [] = RunNormal(app)
            mean = app.ExpParam1.Value;
            stdev = app.ExpParam2.Value;
            u_in = app.upperlim.Value;
            l_in = app.lowerlim.Value;
            if (u_in>l_in)
            variance = stdev^2;

            k = (1/sqrt(2*pi*variance));
            fun = @(x) (x.^3).*(k .* exp( ...
                (  (- ( (x - mean) .^2) ) ...
                ./ (2 .* variance))));

            format long;
            thirdMoment = integral(fun,l_in,u_in);

                app.MeanValueLabel.Text = string(mean);
                app.VarianceValueLabel.Text = string(variance);
                app.ThirdMomentValueLabel.Text = string(thirdMoment);


m = mean;
v = variance;
                 % Define the MGF
            mgff = @(t) exp(mean .* t + 0.5 .* (t.^2) .* variance);
            
            % Define the first derivative of the MGF
            dmgff = @(t) m .* exp(m .* t + (t.^2 .* v)/2) + t .* v .* exp(m .* t + (t.^2 .* v)/2);
            
            % Define the second derivative of the MGF
            ddmgff = @(t) (variance + (mean + variance .* t).^2) .* exp(mean .* t + 0.5 .* (t.^2) .* variance);

            t = linspace(0, app.timelim.Value, 1000); 
            mgfarr = arrayfun(mgff, t);
            dmgffarr = arrayfun(dmgff, t);
            ddmgffarr = arrayfun(ddmgff, t);   

            app.MGFat0LabelVal.Text = string(dmgffarr(1));
            app.MGFat0Label_2Val.Text = string(ddmgffarr(1));

            plot(app.FirMoment, t, dmgffarr);
            plot(app.SecMoment, t, ddmgffarr);
            plot(app.mgf,t, mgfarr);



            else
                            app.InvalidSampleFileWarning.FontColor = "red";

              app.InvalidSampleFileWarning.Text = "Lower limit cannot be bigger than or equal to upper limit";
            end

        end
        
        function [] = RunFile(app)
            app.InvalidSampleFileWarning.FontColor = "red";
            app.InvalidSampleFileWarning.Text = "file loading...";
            s = app.SampleData;
            x = unique(s);
            M = numel(s);
            N = numel(x);


            if (N == M)
                app.FXRV = ones(1,N) ./ N;
            else
                counts = histcounts(s, [x(:); inf]);
                app.FXRV = counts ./ M;
            end
            mean = dot(x, app.FXRV);
            secMoment = dot((x.^2),app.FXRV);
            variance = secMoment - (mean ^ 2);
            thirdMoment = dot((x.^3),app.FXRV);

            app.MeanValueLabel.Text = string(mean);
            app.VarianceValueLabel.Text = string(variance);
            app.ThirdMomentValueLabel.Text = string(thirdMoment);
            Fx = app.FXRV;
            mgff = @(t) sum(exp(x .* t) .* Fx);
            dmgff = @(t) sum(x .* exp(x .* t) .* Fx);
            ddmgff = @(t) sum(x.^2 .* exp(x .* t) .* Fx);

            t = linspace(0, app.timelim.Value, 100); 
            mgfarr = arrayfun(mgff, t);
            dmgffarr = arrayfun(dmgff, t);
            ddmgffarr = arrayfun(ddmgff, t);   

            app.MGFat0LabelVal.Text = string(dmgffarr(1));
            app.MGFat0Label_2Val.Text = string(ddmgffarr(1));

            plot(app.FirMoment, t, dmgffarr);
            plot(app.SecMoment, t, ddmgffarr);
            plot(app.mgf,t, mgfarr);


            app.InvalidSampleFileWarning.Text = "";
        end

    end


    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ImportRandomVariableButton
        function ImportRandomVariableButtonPushed(app, event)
            app.MyFilePath = app.SampleFile.Value;
            try
                app.SampleData = load(app.MyFilePath).s;
                app.InvalidSampleFileWarning.FontColor = "green";
                app.InvalidSampleFileWarning.Text ="File loaded sucessfully";
                app.CanRun = 1;
            catch
                app.InvalidSampleFileWarning.FontColor = "red";
                app.InvalidSampleFileWarning.Text = "You entered an invalid sample file. File has to be a .mat matlab file with your sample stored in a variable named `s`";
                app.CanRun = 0;
            end
        end

        % Value changed function: ExperimenttypeDropDown
        function ExperimenttypeDropDownValueChanged(app, event)
            value = app.ExperimenttypeDropDown.Value;
            if (value == "File Input")
                app.ExpType = "file";
                app.ExpParam1Label.Text = "-";
                app.ExpParam2Label.Text = "-";
                app.ExpParam1.Enable = "off";
                app.ExpParam2.Enable = "off";
                app.upperlim.Enable = "off";
                app.lowerlim.Enable = "off";
                app.ExpParam1Label.Enable = "off";
                app.ExpParam1Label_2.Enable = "off";
                app.ExpParam2Label_2.Enable = "off";
                app.ExpParam2Label.Enable = "off";  

                app.ExpParam1Label_2.Text = "-";
                app.ExpParam2Label_2.Text = "-";
                app.SampleFile.Enable = "on";
                app.ImportRandomVariableButton.Enable = "on";                
            elseif (value == "Uniform Distribution")
                app.ExpType = "uniform";
                app.ExpParam1Label.Text = "A (Start)";
                app.ExpParam2Label.Text = "B (End)";
                app.ExpParam1.Enable = "on";
                app.ExpParam2.Enable = "on";
                app.upperlim.Enable = "on";
                app.lowerlim.Enable = "on";
                app.ExpParam1Label.Enable = "on";
                app.ExpParam1Label_2.Enable = "on";
                app.ExpParam2Label_2.Enable = "on";
                app.ExpParam2Label.Enable = "on";
                app.ExpParam1Label_2.Text = "Lower Limit";
                app.ExpParam2Label_2.Text = "Upper Limit";

                app.SampleFile.Enable = "off";
                app.ImportRandomVariableButton.Enable = "off";

            elseif (value == "Normal Distribution")
                app.ExpType= "normal";
                app.ExpParam1Label.Text = "Mu (Mean)";
                app.ExpParam2Label.Text = "Sigma (Std. Dist.)";
                app.ExpParam1.Enable = "on";
                app.ExpParam2.Enable = "on";
                app.upperlim.Enable = "on";
                app.lowerlim.Enable = "on";
                app.ExpParam1Label.Enable = "on";
                app.ExpParam1Label_2.Enable = "on";
                app.ExpParam2Label_2.Enable = "on";
                app.ExpParam2Label.Enable = "on";
                              app.ExpParam1Label_2.Text = "Lower Limit";
                app.ExpParam2Label_2.Text = "Upper Limit";
                app.SampleFile.Enable = "off";
                app.ImportRandomVariableButton.Enable = "off";                
            end

        end

        % Button pushed function: RunRandomVariableButton
        function RunRandomVariableButtonPushed(app, event)

            if (app.ExpType == "uniform")
                app.RunUniform();
            elseif (app.ExpType == "normal")
                app.RunNormal();
            elseif (app.ExpType == "file")

                if (app.CanRun)
                    app.RunFile()
                else
                    app.InvalidSampleFileWarning.FontColor = "red";
                    app.InvalidSampleFileWarning.Text = "Please enter a (working) sample file";
                end
            end
        end

        % Button pushed function: LOADPROCESSDATAFILESButton
        function LOADPROCESSDATAFILESButtonPushed(app, event)
            [file,path] = uigetfile('*.mat');
            if isequal(file,0)
                app.fileInfo.Text = 'User selected Cancel';
            else
                data = load(fullfile(path, file));
                app.RPX= data.X; 
                app.RPt = data.t;
                app.N=length(app.RPX);
                app.fileInfo.Text = ['File loaded successfully. X size: ', mat2str(size(app.RPX)), ', t size: ', mat2str(size(app.RPt))];
          

                app.ensembleMean = mean(app.RPX, 1);
                plot(app.ensembleGraph, app.RPt, app.ensembleMean);
                

                x = mean(app.RPX, 1);
                y = x;
                max_lag = 101;
                app.R_x = zeros(1, max_lag + 1);
                
                for m = 0:max_lag
                    for n = 1:length(x)
                        if n + m <= length(y)
                            app.R_x(m + 1) = app.R_x(m + 1) + x(n) * y(n + m);
                        end
                    end
                end
                
%               maxR_x = max(app.R_x);
                app.R_x = app.R_x * (1/app.N);
                
                plot(app.autoGraph, 0:max_lag, app.R_x);

                fft_result = fft(app.R_x, app.N);
                fft_values = abs(fft_result).^2 / app.N;
                
                frequencies = (0:app.N-1) / (2*max_lag);
                stem(app.spectralGraph, frequencies, fft_values);
                
                total_average_power = sum(fft_values) * (1 / app.N);
                app.averagePowerLabel.Text = num2str(total_average_power);
            end

            
        end

        % Button pushed function: LoadButton
        function LoadButtonPushed(app, event)
            inputValue = inputdlg('Enter a numerical value:', 'Numeric Input', [1 50]);
            if isempty(inputValue)
                app.sampleFunctionsLabel.Text = 'User canceled input.';
            else
                numericValue = str2double(inputValue{1});
            
                if isnan(numericValue)
                    app.sampleFunctionsLabel.Text = 'Invalid input. Please enter a numerical value.';
                else
                    app.SFM = numericValue;
                    app.sampleFunctionsLabel.Text = ['Value stored: ', num2str(app.SFM)];
            
                    figure('Name', 'Sample Functions', 'NumberTitle', 'off');
            
                    t = app.RPt;
            
                    for row = 1:app.SFM
                        % Create subplots for each row
                        subplot(app.SFM, 1, row);
                        plot(t, app.RPX(row, :));
                        title(['Row ', num2str(row)]);
                        xlabel('Time');
                        ylabel('Amplitude');
                    end
            
                    app.sampleFunctionsLabel.Text = ['Plotted ', num2str(app.SFM), ' rows on the graph.'];
                end
            end
        end

        % Button pushed function: timeMeanButton
        function timeMeanButtonPushed(app, event)
            inputValue = inputdlg('Enter a row number:', 'Row Number Input', [1 50]);
            if isempty(inputValue)
                app.timeMeanLabel.Text = 'User canceled input.';
            else
                rowNumber = str2double(inputValue{1});
                
                if isnan(rowNumber) || rowNumber < 1 || rowNumber > size(app.RPX, 1)
                    app.timeMeanLabel.Text = 'Invalid input. Please enter a valid row number.';
                else
                    app.SFn = rowNumber;
                    app.timeMeanLabel.Text = ['Row number set: ', num2str(app.SFn)];                    
                    selectedSampleFunction = app.RPX(app.SFn, :);
                    timeMeanValue = mean(selectedSampleFunction);
                    app.timeMeanLabel.Text=num2str(timeMeanValue);

                end
            end

        end

        % Button pushed function: autoCorrelationButton
        function autoCorrelationButtonPushed(app, event)
            inputValue = inputdlg('Enter a row number:', 'Row Number Input', [1 50]);
            if isempty(inputValue)
                app.AutoLabel.Text = 'User canceled input.';
            else
                rowNumber = str2double(inputValue{1});
            
                if isnan(rowNumber) || rowNumber < 1 || rowNumber > size(app.RPX, 1)
                    app.AutoLabel.Text = 'Invalid input. Please enter a valid row number.';
                else
                    app.SFn2 = rowNumber;
                    app.AutoLabel.Text = ['Row number set: ', num2str(app.SFn2)];
            
                    max_lag = 101;                    
                    x=app.RPX(app.SFn2, :);
                    y = x;
                    autocorrelation = zeros(1, max_lag + 1);
                    for m = 0:max_lag
                        for n = 1:length(x)
                            if n + m <= length(y)
                                autocorrelation(m + 1) = autocorrelation(m + 1) + x(n) * y(n + m);
                            end
                        end
                    end
                    
 %                  maxAutocorrelation = max(autocorrelation);
 %                  normalized_autocorrelation = autocorrelation / maxAutocorrelation;
                    
                    autocorrelation=autocorrelation*(1/app.N);
                    figure('Name', 'Autocorrelation Function', 'NumberTitle', 'off');
                    
                    plot(0:max_lag, autocorrelation);
                    xlabel('Lag');
                    ylabel('Autocorrelation');
                    title(['Autocorrelation Function for Row ', num2str(app.SFn2)]);
                    
                    app.AutoLabel.Text = ['Plotted Time Autocorrelation Function for Row ', num2str(app.SFn2)];
                end
            end
        end

        % Button pushed function: autoCorrelationButton_2
        function autoCorrelationButton_2Pushed(app, event)
            X = app.RPX;
            p = 1 / size(X, 1);
            [m, n] = size(X);
            R = zeros(m, m);
            
            for i = 1:m
                for j = 1:m
                    R(i, j) = sum(X(:, i) .* X(:, j) * p);
                end
            end
            
%            maxR = max(R(:));
%            normalized_R = R / maxR;
            
            figure;
            surf(R);
            
            title('3D Plot of ACF');
            xlabel('Sample i');
            ylabel('Sample j');
            zlabel('Normalized ACF Value');
            
            grid on;
            view(45, 30);

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 891 909];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [2 1 891 908];

            % Create RandomVariableTab
            app.RandomVariableTab = uitab(app.TabGroup);
            app.RandomVariableTab.Title = 'Random Variable';

            % Create mgf
            app.mgf = uiaxes(app.RandomVariableTab);
            title(app.mgf, 'MGF')
            xlabel(app.mgf, 't')
            ylabel(app.mgf, 'mgf(t)')
            zlabel(app.mgf, 'Z')
            app.mgf.Position = [3 606 480 217];

            % Create FirMoment
            app.FirMoment = uiaxes(app.RandomVariableTab);
            title(app.FirMoment, 'First Moment')
            xlabel(app.FirMoment, 'X')
            ylabel(app.FirMoment, 'd/dt(mgf(t))')
            zlabel(app.FirMoment, 'Z')
            app.FirMoment.Position = [2 350 481 218];

            % Create SecMoment
            app.SecMoment = uiaxes(app.RandomVariableTab);
            title(app.SecMoment, 'Second Moment')
            xlabel(app.SecMoment, 'X')
            ylabel(app.SecMoment, 'd^2/dt^2(mgf(t))')
            zlabel(app.SecMoment, 'Z')
            app.SecMoment.Position = [2 95 481 218];

            % Create ExpParam1
            app.ExpParam1 = uieditfield(app.RandomVariableTab, 'numeric');
            app.ExpParam1.FontSize = 14;
            app.ExpParam1.Enable = 'off';
            app.ExpParam1.Position = [590 119 65 22];

            % Create ExpParam2
            app.ExpParam2 = uieditfield(app.RandomVariableTab, 'numeric');
            app.ExpParam2.FontSize = 14;
            app.ExpParam2.Enable = 'off';
            app.ExpParam2.Position = [783 119 65 22];

            % Create ExpParam1Label
            app.ExpParam1Label = uilabel(app.RandomVariableTab);
            app.ExpParam1Label.HorizontalAlignment = 'right';
            app.ExpParam1Label.FontSize = 14;
            app.ExpParam1Label.Enable = 'off';
            app.ExpParam1Label.Position = [509 119 79 22];
            app.ExpParam1Label.Text = '-';

            % Create ExpParam2Label
            app.ExpParam2Label = uilabel(app.RandomVariableTab);
            app.ExpParam2Label.HorizontalAlignment = 'right';
            app.ExpParam2Label.FontSize = 14;
            app.ExpParam2Label.Enable = 'off';
            app.ExpParam2Label.Position = [654 119 126 22];
            app.ExpParam2Label.Text = '-';

            % Create InvalidSampleFileWarning
            app.InvalidSampleFileWarning = uilabel(app.RandomVariableTab);
            app.InvalidSampleFileWarning.VerticalAlignment = 'bottom';
            app.InvalidSampleFileWarning.WordWrap = 'on';
            app.InvalidSampleFileWarning.FontSize = 14;
            app.InvalidSampleFileWarning.FontColor = [1 0 0];
            app.InvalidSampleFileWarning.Position = [498 638 348 59];
            app.InvalidSampleFileWarning.Text = '';

            % Create CIE327ProjectLabel
            app.CIE327ProjectLabel = uilabel(app.RandomVariableTab);
            app.CIE327ProjectLabel.HorizontalAlignment = 'center';
            app.CIE327ProjectLabel.FontSize = 48;
            app.CIE327ProjectLabel.FontWeight = 'bold';
            app.CIE327ProjectLabel.Position = [499 801 351 62];
            app.CIE327ProjectLabel.Text = 'CIE 327 Project';

            % Create RandomVariableLabel
            app.RandomVariableLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableLabel.HorizontalAlignment = 'center';
            app.RandomVariableLabel.FontSize = 24;
            app.RandomVariableLabel.FontWeight = 'bold';
            app.RandomVariableLabel.Position = [499 771 349 31];
            app.RandomVariableLabel.Text = 'Random Variable';

            % Create RandomVariableVarianceLabel
            app.RandomVariableVarianceLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableVarianceLabel.FontSize = 18;
            app.RandomVariableVarianceLabel.FontWeight = 'bold';
            app.RandomVariableVarianceLabel.Position = [504 467 241 27];
            app.RandomVariableVarianceLabel.Text = 'Random Variable Variance:';

            % Create VarianceValueLabel
            app.VarianceValueLabel = uilabel(app.RandomVariableTab);
            app.VarianceValueLabel.BackgroundColor = [0.8 0.8 0.8];
            app.VarianceValueLabel.HorizontalAlignment = 'center';
            app.VarianceValueLabel.FontWeight = 'bold';
            app.VarianceValueLabel.FontColor = [0.502 0.502 0.502];
            app.VarianceValueLabel.Position = [502 431 347 37];
            app.VarianceValueLabel.Text = 'VarianceValue';

            % Create RandomVariableThirdMomentLabel
            app.RandomVariableThirdMomentLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableThirdMomentLabel.FontSize = 18;
            app.RandomVariableThirdMomentLabel.FontWeight = 'bold';
            app.RandomVariableThirdMomentLabel.Position = [501 354 284 27];
            app.RandomVariableThirdMomentLabel.Text = 'Random Variable Third Moment:';

            % Create ThirdMomentValueLabel
            app.ThirdMomentValueLabel = uilabel(app.RandomVariableTab);
            app.ThirdMomentValueLabel.BackgroundColor = [0.8 0.8 0.8];
            app.ThirdMomentValueLabel.HorizontalAlignment = 'center';
            app.ThirdMomentValueLabel.FontWeight = 'bold';
            app.ThirdMomentValueLabel.FontColor = [0.502 0.502 0.502];
            app.ThirdMomentValueLabel.Position = [501 318 346 37];
            app.ThirdMomentValueLabel.Text = 'ThirdMomentValue';

            % Create RandomVariableMeanLabel
            app.RandomVariableMeanLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableMeanLabel.FontSize = 18;
            app.RandomVariableMeanLabel.FontWeight = 'bold';
            app.RandomVariableMeanLabel.Position = [503 580 209 27];
            app.RandomVariableMeanLabel.Text = 'Random Variable Mean:';

            % Create MeanValueLabel
            app.MeanValueLabel = uilabel(app.RandomVariableTab);
            app.MeanValueLabel.BackgroundColor = [0.8 0.8 0.8];
            app.MeanValueLabel.HorizontalAlignment = 'center';
            app.MeanValueLabel.FontWeight = 'bold';
            app.MeanValueLabel.FontColor = [0.502 0.502 0.502];
            app.MeanValueLabel.Position = [503 544 345 37];
            app.MeanValueLabel.Text = 'MeanValue';

            % Create ImportRandomVariableButton
            app.ImportRandomVariableButton = uibutton(app.RandomVariableTab, 'push');
            app.ImportRandomVariableButton.ButtonPushedFcn = createCallbackFcn(app, @ImportRandomVariableButtonPushed, true);
            app.ImportRandomVariableButton.BackgroundColor = [0.902 0.902 0.902];
            app.ImportRandomVariableButton.FontSize = 14;
            app.ImportRandomVariableButton.FontWeight = 'bold';
            app.ImportRandomVariableButton.Position = [754 18 100 62];
            app.ImportRandomVariableButton.Text = {'Import '; 'Random'; 'Variable'};

            % Create RunRandomVariableButton
            app.RunRandomVariableButton = uibutton(app.RandomVariableTab, 'push');
            app.RunRandomVariableButton.ButtonPushedFcn = createCallbackFcn(app, @RunRandomVariableButtonPushed, true);
            app.RunRandomVariableButton.FontWeight = 'bold';
            app.RunRandomVariableButton.Position = [509 220 347 34];
            app.RunRandomVariableButton.Text = 'Run Random Variable';

            % Create SampleFile
            app.SampleFile = uieditfield(app.RandomVariableTab, 'text');
            app.SampleFile.HorizontalAlignment = 'center';
            app.SampleFile.Placeholder = 'EnterSampleFile.m';
            app.SampleFile.Position = [506 18 234 61];

            % Create ExperimenttypeDropDownLabel
            app.ExperimenttypeDropDownLabel = uilabel(app.RandomVariableTab);
            app.ExperimenttypeDropDownLabel.HorizontalAlignment = 'right';
            app.ExperimenttypeDropDownLabel.FontSize = 14;
            app.ExperimenttypeDropDownLabel.Position = [509 87 106 22];
            app.ExperimenttypeDropDownLabel.Text = 'Experiment type';

            % Create ExperimenttypeDropDown
            app.ExperimenttypeDropDown = uidropdown(app.RandomVariableTab);
            app.ExperimenttypeDropDown.Items = {'File Input', 'Uniform Distribution', 'Normal Distribution'};
            app.ExperimenttypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ExperimenttypeDropDownValueChanged, true);
            app.ExperimenttypeDropDown.FontSize = 14;
            app.ExperimenttypeDropDown.Position = [623 87 224 22];
            app.ExperimenttypeDropDown.Value = 'File Input';

            % Create SaifeldenMohamedLabel
            app.SaifeldenMohamedLabel = uilabel(app.RandomVariableTab);
            app.SaifeldenMohamedLabel.FontSize = 22;
            app.SaifeldenMohamedLabel.FontWeight = 'bold';
            app.SaifeldenMohamedLabel.Position = [499 715 351 47];
            app.SaifeldenMohamedLabel.Text = 'Saifelden Mohamed ';

            % Create AserOsamaLabel
            app.AserOsamaLabel = uilabel(app.RandomVariableTab);
            app.AserOsamaLabel.FontSize = 22;
            app.AserOsamaLabel.FontWeight = 'bold';
            app.AserOsamaLabel.Position = [498 696 349 37];
            app.AserOsamaLabel.Text = 'Aser Osama';

            % Create Label
            app.Label = uilabel(app.RandomVariableTab);
            app.Label.HorizontalAlignment = 'right';
            app.Label.FontSize = 22;
            app.Label.FontWeight = 'bold';
            app.Label.Position = [500 715 347 47];
            app.Label.Text = '202100432';

            % Create Label_2
            app.Label_2 = uilabel(app.RandomVariableTab);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.FontSize = 22;
            app.Label_2.FontWeight = 'bold';
            app.Label_2.Position = [498 696 349 37];
            app.Label_2.Text = '202101266';

            % Create lowerlim
            app.lowerlim = uieditfield(app.RandomVariableTab, 'numeric');
            app.lowerlim.FontSize = 14;
            app.lowerlim.Enable = 'off';
            app.lowerlim.Position = [591 148 65 22];

            % Create upperlim
            app.upperlim = uieditfield(app.RandomVariableTab, 'numeric');
            app.upperlim.FontSize = 14;
            app.upperlim.Enable = 'off';
            app.upperlim.Position = [784 148 65 22];

            % Create ExpParam1Label_2
            app.ExpParam1Label_2 = uilabel(app.RandomVariableTab);
            app.ExpParam1Label_2.HorizontalAlignment = 'right';
            app.ExpParam1Label_2.FontSize = 14;
            app.ExpParam1Label_2.Enable = 'off';
            app.ExpParam1Label_2.Position = [510 148 79 22];
            app.ExpParam1Label_2.Text = '-';

            % Create ExpParam2Label_2
            app.ExpParam2Label_2 = uilabel(app.RandomVariableTab);
            app.ExpParam2Label_2.HorizontalAlignment = 'right';
            app.ExpParam2Label_2.FontSize = 14;
            app.ExpParam2Label_2.Enable = 'off';
            app.ExpParam2Label_2.Position = [655 148 126 22];
            app.ExpParam2Label_2.Text = '-';

            % Create timelim
            app.timelim = uieditfield(app.RandomVariableTab, 'numeric');
            app.timelim.FontSize = 14;
            app.timelim.Position = [784 179 63 22];
            
            % Create MGFat0Label
            app.MGFat0Label = uilabel(app.RandomVariableTab);
            app.MGFat0Label.FontSize = 18;
            app.MGFat0Label.Position = [9 56 109 23];
            app.MGFat0Label.Text = 'MGF'' at 0';

            % Create MGFat0Label_2
            app.MGFat0Label_2 = uilabel(app.RandomVariableTab);
            app.MGFat0Label_2.FontSize = 18;
            app.MGFat0Label_2.Position = [9 34 110 23];
            app.MGFat0Label_2.Text = 'MGF'''' at 0';

            % Create MGFat0LabelVal
            app.MGFat0LabelVal = uilabel(app.RandomVariableTab);
            app.MGFat0LabelVal.FontSize = 18;
            app.MGFat0LabelVal.Position = [118 56 365 23];
            app.MGFat0LabelVal.Text = '-';

            % Create MGFat0Label_2Val
            app.MGFat0Label_2Val = uilabel(app.RandomVariableTab);
            app.MGFat0Label_2Val.FontSize = 18;
            app.MGFat0Label_2Val.Position = [118 34 365 23];
            app.MGFat0Label_2Val.Text = '-';

            % Create MGFtimeupperlimitLabel
            app.MGFtimeupperlimitLabel = uilabel(app.RandomVariableTab);
            app.MGFtimeupperlimitLabel.FontSize = 14;
            app.MGFtimeupperlimitLabel.Position = [645 179 135 22];
            app.MGFtimeupperlimitLabel.Text = 'MGF time upper limit';

            % Create RandomProcessTab_2
            app.RandomProcessTab_2 = uitab(app.TabGroup);
            app.RandomProcessTab_2.Title = 'Random Process';

            % Create ensembleGraph
            app.ensembleGraph = uiaxes(app.RandomProcessTab_2);
            title(app.ensembleGraph, 'Ensemble Mean')
            xlabel(app.ensembleGraph, 'X')
            ylabel(app.ensembleGraph, 'Y')
            zlabel(app.ensembleGraph, 'Z')
            app.ensembleGraph.Position = [47 616-100 814 296];

            % Create autoGraph
            app.autoGraph = uiaxes(app.RandomProcessTab_2);
            title(app.autoGraph, 'auto-correlation function')
            xlabel(app.autoGraph, 'Time Delay (s)')
            ylabel(app.autoGraph, 'autocorrelation ')
            app.autoGraph.Position = [47 332-100 395 285];

            % Create spectralGraph
            app.spectralGraph = uiaxes(app.RandomProcessTab_2);
            title(app.spectralGraph, 'Power Spectral Density')
            xlabel(app.spectralGraph, 'Frequency (Hz)')
            ylabel(app.spectralGraph, 'Power\Frequency (Watt\Hz)')
            zlabel(app.spectralGraph, 'Z')
            app.spectralGraph.Position = [450 332-100 411 285];

            % Create Label_4
            app.Label_4 = uilabel(app.RandomProcessTab_2);
            app.Label_4.Position = [1 688 2 2];

            % Create LOADPROCESSDATAFILESButton
            app.LOADPROCESSDATAFILESButton = uibutton(app.RandomProcessTab_2, 'push');
            app.LOADPROCESSDATAFILESButton.ButtonPushedFcn = createCallbackFcn(app, @LOADPROCESSDATAFILESButtonPushed, true);
            app.LOADPROCESSDATAFILESButton.Position = [148 931-100 270 28];
            app.LOADPROCESSDATAFILESButton.Text = 'LOAD PROCESS DATA FILES';

            % Create fileInfo
            app.fileInfo = uilabel(app.RandomProcessTab_2);
            app.fileInfo.BackgroundColor = [0.902 0.902 0.902];
            app.fileInfo.FontSize = 14;
            app.fileInfo.Position = [450 931-100 356 28];
            app.fileInfo.Text = '';

            % Create TimeMeanofnthsamplefunctionLabel_2
            app.TimeMeanofnthsamplefunctionLabel_2 = uilabel(app.RandomProcessTab_2);
            app.TimeMeanofnthsamplefunctionLabel_2.Position = [147 224-100 240 29];
            app.TimeMeanofnthsamplefunctionLabel_2.Text = 'Time Mean of nth sample function';

            % Create timeMeanLabel
            app.timeMeanLabel = uilabel(app.RandomProcessTab_2);
            app.timeMeanLabel.BackgroundColor = [0.902 0.902 0.902];
            app.timeMeanLabel.Position = [518 227-100 269 29];
            app.timeMeanLabel.Text = '';

            % Create timeMeanButton
            app.timeMeanButton = uibutton(app.RandomProcessTab_2, 'push');
            app.timeMeanButton.ButtonPushedFcn = createCallbackFcn(app, @timeMeanButtonPushed, true);
            app.timeMeanButton.Position = [402 230-100 98 23];
            app.timeMeanButton.Text = 'Load';

            % Create TimeAutocorrelationofnthsamplefunctionLabel
            app.TimeAutocorrelationofnthsamplefunctionLabel = uilabel(app.RandomProcessTab_2);
            app.TimeAutocorrelationofnthsamplefunctionLabel.Position = [147 191-100 240 29];
            app.TimeAutocorrelationofnthsamplefunctionLabel.Text = 'Time Autocorrelation of nth sample function';

            % Create autoCorrelationButton
            app.autoCorrelationButton = uibutton(app.RandomProcessTab_2, 'push');
            app.autoCorrelationButton.ButtonPushedFcn = createCallbackFcn(app, @autoCorrelationButtonPushed, true);
            app.autoCorrelationButton.Position = [402 194-100 98 23];
            app.autoCorrelationButton.Text = 'Load';

            % Create AutoLabel
            app.AutoLabel = uilabel(app.RandomProcessTab_2);
            app.AutoLabel.BackgroundColor = [0.902 0.902 0.902];
            app.AutoLabel.Position = [519 191-100 269 29];
            app.AutoLabel.Text = '';

            % Create LoadButton
            app.LoadButton = uibutton(app.RandomProcessTab_2, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [402 156-100 98 25];
            app.LoadButton.Text = 'Load';

            % Create sampleFunctionsLabel
            app.sampleFunctionsLabel = uilabel(app.RandomProcessTab_2);
            app.sampleFunctionsLabel.BackgroundColor = [0.902 0.902 0.902];
            app.sampleFunctionsLabel.FontSize = 14;
            app.sampleFunctionsLabel.Position = [518 154-100 269 29];
            app.sampleFunctionsLabel.Text = '';

            % Create TotalAveragePowerLabel
            app.TotalAveragePowerLabel = uilabel(app.RandomProcessTab_2);
            app.TotalAveragePowerLabel.FontSize = 14;
            app.TotalAveragePowerLabel.Position = [257 280-100 140 22];
            app.TotalAveragePowerLabel.Text = 'Total Average Power: ';

            % Create averagePowerLabel
            app.averagePowerLabel = uilabel(app.RandomProcessTab_2);
            app.averagePowerLabel.BackgroundColor = [0.902 0.902 0.902];
            app.averagePowerLabel.FontSize = 14;
            app.averagePowerLabel.Position = [396 277-100 225 28];
            app.averagePowerLabel.Text = '';

            % Create WattLabel
            app.WattLabel = uilabel(app.RandomProcessTab_2);
            app.WattLabel.FontSize = 14;
            app.WattLabel.Position = [630 277-100 33 22];
            app.WattLabel.Text = 'Watt';

            % Create PlotNnumberofsamplefunctionsLabel
            app.PlotNnumberofsamplefunctionsLabel = uilabel(app.RandomProcessTab_2);
            app.PlotNnumberofsamplefunctionsLabel.Position = [147 154-100 240 29];
            app.PlotNnumberofsamplefunctionsLabel.Text = 'Plot N number of sample functions';

            % Create TimeAutocorrelation3DPlotLabel
            app.TimeAutocorrelation3DPlotLabel = uilabel(app.RandomProcessTab_2);
            app.TimeAutocorrelation3DPlotLabel.Position = [476 106 237 29];
            app.TimeAutocorrelation3DPlotLabel.Text = 'Time Autocorrelation 3D Plot';

            % Create autoCorrelationButton_2
            app.autoCorrelationButton_2 = uibutton(app.RandomProcessTab_2, 'push');
            app.autoCorrelationButton_2.ButtonPushedFcn = createCallbackFcn(app, @autoCorrelationButton_2Pushed, true);
            app.autoCorrelationButton_2.Position = [723 109 66 23];
            app.autoCorrelationButton_2.Text = 'Load';

            % Create AutoLabel_2
            app.AutoLabel_2 = uilabel(app.RandomProcessTab_2);
            app.AutoLabel_2.BackgroundColor = [0.902 0.902 0.902];
            app.AutoLabel_2.Position = [476 66 313 29];
            app.AutoLabel_2.Text = '';

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.UIFigure);

            % Create Menu
            app.Menu = uimenu(app.ContextMenu);
            app.Menu.Text = 'Menu';

            % Create Menu2
            app.Menu2 = uimenu(app.ContextMenu);
            app.Menu2.Text = 'Menu2';

            % Create ContextMenu2
            app.ContextMenu2 = uicontextmenu(app.UIFigure);

            % Create Menu_2
            app.Menu_2 = uimenu(app.ContextMenu2);
            app.Menu_2.Text = 'Menu';

            % Create Menu2_2
            app.Menu2_2 = uimenu(app.ContextMenu2);
            app.Menu2_2.Text = 'Menu2';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end