classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        RandomVariableTab               matlab.ui.container.Tab
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
        GarbageLabel                    matlab.ui.control.Label
        ExpParam2Label                  matlab.ui.control.Label
        ExpParam1Label                  matlab.ui.control.Label
        ExpParam2                       matlab.ui.control.NumericEditField
        ExpParam1                       matlab.ui.control.NumericEditField
        SecMoment                       matlab.ui.control.UIAxes
        FirMoment                       matlab.ui.control.UIAxes
        mgf                             matlab.ui.control.UIAxes
        RandomProcessTab_2              matlab.ui.container.Tab
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
        ExpType = "uniform" % Description
        RPt
        RPX
        SFM
        SFn
        SFn2
        ensembleMean
        R_x
    end

    methods (Access = private)


        function [] = RunUniform(app)
            app.GarbageLabel.Text = "UNIFORM";
            a_in = app.ExpParam1.Value;
            b_in = app.ExpParam2.Value;
            x = sort(app.SampleData);
            if ((a_in < x(end) && b_in > x(1)))
                if (x(1) > a_in)
                    a = x(1);
                else
                    %                 closest = find( min( abs(x-a_in) )== abs(x-a_in) );
                    %                 a = x(closest);
                    a = a_in;
                end
                if (x(end) < b_in)
                    b = x(end);
                else
                    %                 closest = find( min( abs(x-b_in) )== abs(x-b_in) );
                    %                 b = x(closest);
                    b = b_in;

                end
                app.InvalidSampleFileWarning.Text = "";
            else
                a = 0;
                b = 0;
                app.InvalidSampleFileWarning.FontColor = "red";
                app.InvalidSampleFileWarning.Text = "A & B out of range of sample file.";
            end
            mean = (a + b) / 2;
            variance = ((b-a) ^ 2)/12;
            x3_fx = @(x) (1/(b-a)) .* x.^3;
            thirdMoment = integral(x3_fx, a, b);
            app.MeanValueLabel.Text = string(mean);
            app.VarianceValueLabel.Text = string(variance);
            app.ThirdMomentValueLabel.Text = string(thirdMoment);
% % 
        end

        function [] = RunNormal(app)
            app.GarbageLabel.Text = "NORMAL";
            mean = app.ExpParam1.Value;
            stdev = app.ExpParam2.Value;
            variance = stdev^2;

            x = sort(app.SampleData);

            k = (1/sqrt(2*pi*variance));
            fun = @(x) (x.^3).*(k .* exp( ...
                (  (- ( (x - mean) .^2) ) ...
                ./ (2 .* variance))));

            format long;
            thirdMoment = integral(fun,x(1),x(end));

            app.MeanValueLabel.Text = string(mean);
            app.VarianceValueLabel.Text = string(variance);
            app.ThirdMomentValueLabel.Text = string(thirdMoment);
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
            if (value == "Uniform Distribution")
                app.ExpType = "uniform";
                app.ExpParam1Label.Text = "A (Start)";
                app.ExpParam2Label.Text = "B (End)";
            else
                if (value == "Normal Distribution")
                    app.ExpType= "normal";
                    app.ExpParam1Label.Text = "Mu (Mean)";
                    app.ExpParam2Label.Text = "Sigma (Std. Dist.)";
                end
            end
        end

        % Button pushed function: RunRandomVariableButton
        function RunRandomVariableButtonPushed(app, event)
            if (app.CanRun)
                app.SampleData = sort(app.SampleData);

                if (app.ExpType == "uniform")
                    app.RunUniform();
                elseif (app.ExpType == "normal")
                    app.RunNormal();
                end
            else
                app.InvalidSampleFileWarning.FontColor = "red";
                app.InvalidSampleFileWarning.Text = "Please enter a (working) sample file";

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
                app.fileInfo.Text = ['File loaded successfully. X size: ', mat2str(size(app.RPX)), ', t size: ', mat2str(size(app.RPt))];
          
                N=length(app.RPX);

                app.ensembleMean = mean(app.RPX, 1);
                plot(app.ensembleGraph, app.RPt, app.ensembleMean);
                

                x = mean(app.RPX, 1);
                y = x;
                
                max_lag = 101;
                app.R_x = zeros(1, 2*max_lag + 1);
                
                for m = -max_lag:max_lag
                    for n = 1:length(x)
                        if n + m > 0 && n + m <= length(y)
                            app.R_x(m + max_lag + 1) = app.R_x(m + max_lag + 1) + x(n) * y(n + m);
                        end
                    end
                end
                lag_values = -max_lag:max_lag;
                app.R_x= app.R_x / app.R_x(max_lag + 1);

           
                plot(app.autoGraph, lag_values, app.R_x);


                fs = 1 / (app.RPt(2) - app.RPt(1));
                psd = abs(fft(app.R_x)).^2 / N;
                freq = linspace(0, fs/2, length(psd));
                stem(app.spectralGraph, freq, psd);
                                
                df = freq(2) - freq(1);
                total_avg_power = sum(psd) * df;

                display(total_avg_power);
            
                app.averagePowerLabel.Text = num2str(total_avg_power);
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
                    lag_values = -max_lag:max_lag;
                    x=app.RPX(app.SFn2, :);
                    y = x;
                    
                    autocorrelation = zeros(1, 2*max_lag + 1);
                    
                    for m = -max_lag:max_lag
                        for n = 1:length(x)
                            if n + m > 0 && n + m <= length(y)
                                autocorrelation(m + max_lag + 1) = autocorrelation(m + max_lag + 1) + x(n) * y(n + m);
                            end
                        end
                    end

                    autocorrelation = autocorrelation / autocorrelation(max_lag + 1);



                    figure('Name', 'Autocorrelation Function', 'NumberTitle', 'off');

                    plot(lag_values, autocorrelation);
                    xlabel('Lag');
                    ylabel('Autocorrelation');
                    title(['Autocorrelation Function for Row ', num2str(app.SFn2)]);
            
                    app.AutoLabel.Text = ['Plotted Autocorrelation Function for Row ', num2str(app.SFn2)];
                end
            end
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
            app.TabGroup.Position = [2 -95 908 1004];

            % Create RandomVariableTab
            app.RandomVariableTab = uitab(app.TabGroup);
            app.RandomVariableTab.Title = 'Random Variable';

            % Create mgf
            app.mgf = uiaxes(app.RandomVariableTab);
            title(app.mgf, 'MGF')
            xlabel(app.mgf, 'X')
            ylabel(app.mgf, 'Y')
            zlabel(app.mgf, 'Z')
            app.mgf.Position = [1 671 486 300];

            % Create FirMoment
            app.FirMoment = uiaxes(app.RandomVariableTab);
            title(app.FirMoment, 'First Moment')
            xlabel(app.FirMoment, 'X')
            ylabel(app.FirMoment, 'Y')
            zlabel(app.FirMoment, 'Z')
            app.FirMoment.Position = [0 350 487 301];

            % Create SecMoment
            app.SecMoment = uiaxes(app.RandomVariableTab);
            title(app.SecMoment, 'Second Moment')
            xlabel(app.SecMoment, 'X')
            ylabel(app.SecMoment, 'Y')
            zlabel(app.SecMoment, 'Z')
            app.SecMoment.Position = [0 29 487 301];

            % Create ExpParam1
            app.ExpParam1 = uieditfield(app.RandomVariableTab, 'numeric');
            app.ExpParam1.FontSize = 14;
            app.ExpParam1.Position = [620 155 65 22];

            % Create ExpParam2
            app.ExpParam2 = uieditfield(app.RandomVariableTab, 'numeric');
            app.ExpParam2.FontSize = 14;
            app.ExpParam2.Position = [813 155 65 22];

            % Create ExpParam1Label
            app.ExpParam1Label = uilabel(app.RandomVariableTab);
            app.ExpParam1Label.HorizontalAlignment = 'right';
            app.ExpParam1Label.FontSize = 14;
            app.ExpParam1Label.Position = [539 155 79 22];
            app.ExpParam1Label.Text = 'A (Start)';

            % Create ExpParam2Label
            app.ExpParam2Label = uilabel(app.RandomVariableTab);
            app.ExpParam2Label.HorizontalAlignment = 'right';
            app.ExpParam2Label.FontSize = 14;
            app.ExpParam2Label.Position = [684 155 126 22];
            app.ExpParam2Label.Text = 'B (End)';

            % Create GarbageLabel
            app.GarbageLabel = uilabel(app.RandomVariableTab);
            app.GarbageLabel.BackgroundColor = [1 0 0];
            app.GarbageLabel.FontSize = 36;
            app.GarbageLabel.Position = [529 706 145 47];
            app.GarbageLabel.Text = 'Garbage';

            % Create InvalidSampleFileWarning
            app.InvalidSampleFileWarning = uilabel(app.RandomVariableTab);
            app.InvalidSampleFileWarning.VerticalAlignment = 'bottom';
            app.InvalidSampleFileWarning.WordWrap = 'on';
            app.InvalidSampleFileWarning.FontSize = 14;
            app.InvalidSampleFileWarning.FontColor = [1 0 0];
            app.InvalidSampleFileWarning.Position = [541 227 348 59];
            app.InvalidSampleFileWarning.Text = '';

            % Create CIE327ProjectLabel
            app.CIE327ProjectLabel = uilabel(app.RandomVariableTab);
            app.CIE327ProjectLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.CIE327ProjectLabel.HorizontalAlignment = 'center';
            app.CIE327ProjectLabel.FontSize = 48;
            app.CIE327ProjectLabel.FontWeight = 'bold';
            app.CIE327ProjectLabel.Position = [485 897 422 62];
            app.CIE327ProjectLabel.Text = 'CIE 327 Project';

            % Create RandomVariableLabel
            app.RandomVariableLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.RandomVariableLabel.HorizontalAlignment = 'center';
            app.RandomVariableLabel.FontSize = 24;
            app.RandomVariableLabel.FontWeight = 'bold';
            app.RandomVariableLabel.Position = [486 867 421 31];
            app.RandomVariableLabel.Text = 'Random Variable';

            % Create RandomVariableVarianceLabel
            app.RandomVariableVarianceLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableVarianceLabel.FontSize = 18;
            app.RandomVariableVarianceLabel.FontWeight = 'bold';
            app.RandomVariableVarianceLabel.Position = [530 527 241 27];
            app.RandomVariableVarianceLabel.Text = 'Random Variable Variance:';

            % Create VarianceValueLabel
            app.VarianceValueLabel = uilabel(app.RandomVariableTab);
            app.VarianceValueLabel.BackgroundColor = [0.8 0.8 0.8];
            app.VarianceValueLabel.HorizontalAlignment = 'center';
            app.VarianceValueLabel.FontWeight = 'bold';
            app.VarianceValueLabel.FontColor = [0.502 0.502 0.502];
            app.VarianceValueLabel.Position = [528 491 350 37];
            app.VarianceValueLabel.Text = 'VarianceValue';

            % Create RandomVariableThirdMomentLabel
            app.RandomVariableThirdMomentLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableThirdMomentLabel.FontSize = 18;
            app.RandomVariableThirdMomentLabel.FontWeight = 'bold';
            app.RandomVariableThirdMomentLabel.Position = [530 402 284 27];
            app.RandomVariableThirdMomentLabel.Text = 'Random Variable Third Moment:';

            % Create ThirdMomentValueLabel
            app.ThirdMomentValueLabel = uilabel(app.RandomVariableTab);
            app.ThirdMomentValueLabel.BackgroundColor = [0.8 0.8 0.8];
            app.ThirdMomentValueLabel.HorizontalAlignment = 'center';
            app.ThirdMomentValueLabel.FontWeight = 'bold';
            app.ThirdMomentValueLabel.FontColor = [0.502 0.502 0.502];
            app.ThirdMomentValueLabel.Position = [530 366 350 37];
            app.ThirdMomentValueLabel.Text = 'ThirdMomentValue';

            % Create RandomVariableMeanLabel
            app.RandomVariableMeanLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableMeanLabel.FontSize = 18;
            app.RandomVariableMeanLabel.FontWeight = 'bold';
            app.RandomVariableMeanLabel.Position = [528 643 209 27];
            app.RandomVariableMeanLabel.Text = 'Random Variable Mean:';

            % Create MeanValueLabel
            app.MeanValueLabel = uilabel(app.RandomVariableTab);
            app.MeanValueLabel.BackgroundColor = [0.8 0.8 0.8];
            app.MeanValueLabel.HorizontalAlignment = 'center';
            app.MeanValueLabel.FontWeight = 'bold';
            app.MeanValueLabel.FontColor = [0.502 0.502 0.502];
            app.MeanValueLabel.Position = [528 607 350 37];
            app.MeanValueLabel.Text = 'MeanValue';

            % Create ImportRandomVariableButton
            app.ImportRandomVariableButton = uibutton(app.RandomVariableTab, 'push');
            app.ImportRandomVariableButton.ButtonPushedFcn = createCallbackFcn(app, @ImportRandomVariableButtonPushed, true);
            app.ImportRandomVariableButton.BackgroundColor = [0.902 0.902 0.902];
            app.ImportRandomVariableButton.FontSize = 14;
            app.ImportRandomVariableButton.FontWeight = 'bold';
            app.ImportRandomVariableButton.Position = [778 43 100 62];
            app.ImportRandomVariableButton.Text = {'Import '; 'Random'; 'Variable'};

            % Create RunRandomVariableButton
            app.RunRandomVariableButton = uibutton(app.RandomVariableTab, 'push');
            app.RunRandomVariableButton.ButtonPushedFcn = createCallbackFcn(app, @RunRandomVariableButtonPushed, true);
            app.RunRandomVariableButton.FontWeight = 'bold';
            app.RunRandomVariableButton.Position = [530 194 347 34];
            app.RunRandomVariableButton.Text = 'Run Random Variable';

            % Create SampleFile
            app.SampleFile = uieditfield(app.RandomVariableTab, 'text');
            app.SampleFile.HorizontalAlignment = 'center';
            app.SampleFile.Placeholder = 'EnterSampleFile.m';
            app.SampleFile.Position = [530 43 234 61];

            % Create ExperimenttypeDropDownLabel
            app.ExperimenttypeDropDownLabel = uilabel(app.RandomVariableTab);
            app.ExperimenttypeDropDownLabel.HorizontalAlignment = 'right';
            app.ExperimenttypeDropDownLabel.FontSize = 14;
            app.ExperimenttypeDropDownLabel.Position = [539 123 106 22];
            app.ExperimenttypeDropDownLabel.Text = 'Experiment type';

            % Create ExperimenttypeDropDown
            app.ExperimenttypeDropDown = uidropdown(app.RandomVariableTab);
            app.ExperimenttypeDropDown.Items = {'Uniform Distribution', 'Normal Distribution'};
            app.ExperimenttypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ExperimenttypeDropDownValueChanged, true);
            app.ExperimenttypeDropDown.FontSize = 14;
            app.ExperimenttypeDropDown.Position = [653 123 224 22];
            app.ExperimenttypeDropDown.Value = 'Uniform Distribution';

            % Create SaifeldenMohamedLabel
            app.SaifeldenMohamedLabel = uilabel(app.RandomVariableTab);
            app.SaifeldenMohamedLabel.FontSize = 22;
            app.SaifeldenMohamedLabel.FontWeight = 'bold';
            app.SaifeldenMohamedLabel.Position = [529 811 351 47];
            app.SaifeldenMohamedLabel.Text = 'Saifelden Mohamed ';

            % Create AserOsamaLabel
            app.AserOsamaLabel = uilabel(app.RandomVariableTab);
            app.AserOsamaLabel.FontSize = 22;
            app.AserOsamaLabel.FontWeight = 'bold';
            app.AserOsamaLabel.Position = [528 792 349 37];
            app.AserOsamaLabel.Text = 'Aser Osama';

            % Create Label
            app.Label = uilabel(app.RandomVariableTab);
            app.Label.HorizontalAlignment = 'right';
            app.Label.FontSize = 22;
            app.Label.FontWeight = 'bold';
            app.Label.Position = [530 811 347 47];
            app.Label.Text = '202100432';

            % Create Label_2
            app.Label_2 = uilabel(app.RandomVariableTab);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.FontSize = 22;
            app.Label_2.FontWeight = 'bold';
            app.Label_2.Position = [528 792 349 37];
            app.Label_2.Text = '202101266';

            % Create RandomProcessTab_2
            app.RandomProcessTab_2 = uitab(app.TabGroup);
            app.RandomProcessTab_2.Title = 'Random Process';

            % Create ensembleGraph
            app.ensembleGraph = uiaxes(app.RandomProcessTab_2);
            title(app.ensembleGraph, 'Ensemble Mean')
            xlabel(app.ensembleGraph, 'X')
            ylabel(app.ensembleGraph, 'Y')
            zlabel(app.ensembleGraph, 'Z')
            app.ensembleGraph.Position = [47 616 814 296];

            % Create autoGraph
            app.autoGraph = uiaxes(app.RandomProcessTab_2);
            title(app.autoGraph, 'auto-correlation function')
            xlabel(app.autoGraph, 'Time Delay (s)')
            ylabel(app.autoGraph, 'autocorrelation ')
            app.autoGraph.Position = [47 332 395 285];

            % Create spectralGraph
            app.spectralGraph = uiaxes(app.RandomProcessTab_2);
            title(app.spectralGraph, 'Power Spectral Density')
            xlabel(app.spectralGraph, 'Frequency (Hz)')
            ylabel(app.spectralGraph, 'Power\Frequency (Watt\Hz)')
            zlabel(app.spectralGraph, 'Z')
            app.spectralGraph.Position = [450 332 411 285];

            % Create Label_4
            app.Label_4 = uilabel(app.RandomProcessTab_2);
            app.Label_4.Position = [1 784 2 2];

            % Create LOADPROCESSDATAFILESButton
            app.LOADPROCESSDATAFILESButton = uibutton(app.RandomProcessTab_2, 'push');
            app.LOADPROCESSDATAFILESButton.ButtonPushedFcn = createCallbackFcn(app, @LOADPROCESSDATAFILESButtonPushed, true);
            app.LOADPROCESSDATAFILESButton.Position = [148 931 270 28];
            app.LOADPROCESSDATAFILESButton.Text = 'LOAD PROCESS DATA FILES';

            % Create fileInfo
            app.fileInfo = uilabel(app.RandomProcessTab_2);
            app.fileInfo.BackgroundColor = [0.902 0.902 0.902];
            app.fileInfo.FontSize = 14;
            app.fileInfo.Position = [450 931 356 28];
            app.fileInfo.Text = '';

            % Create TimeMeanofnthsamplefunctionLabel_2
            app.TimeMeanofnthsamplefunctionLabel_2 = uilabel(app.RandomProcessTab_2);
            app.TimeMeanofnthsamplefunctionLabel_2.Position = [147 224 240 29];
            app.TimeMeanofnthsamplefunctionLabel_2.Text = 'Time Mean of nth sample function';

            % Create timeMeanLabel
            app.timeMeanLabel = uilabel(app.RandomProcessTab_2);
            app.timeMeanLabel.BackgroundColor = [0.902 0.902 0.902];
            app.timeMeanLabel.Position = [518 227 269 29];
            app.timeMeanLabel.Text = '';

            % Create timeMeanButton
            app.timeMeanButton = uibutton(app.RandomProcessTab_2, 'push');
            app.timeMeanButton.ButtonPushedFcn = createCallbackFcn(app, @timeMeanButtonPushed, true);
            app.timeMeanButton.Position = [402 230 98 23];
            app.timeMeanButton.Text = 'Load';

            % Create TimeAutocorrelationofnthsamplefunctionLabel
            app.TimeAutocorrelationofnthsamplefunctionLabel = uilabel(app.RandomProcessTab_2);
            app.TimeAutocorrelationofnthsamplefunctionLabel.Position = [147 191 240 29];
            app.TimeAutocorrelationofnthsamplefunctionLabel.Text = 'Time Autocorrelation of nth sample function';

            % Create autoCorrelationButton
            app.autoCorrelationButton = uibutton(app.RandomProcessTab_2, 'push');
            app.autoCorrelationButton.ButtonPushedFcn = createCallbackFcn(app, @autoCorrelationButtonPushed, true);
            app.autoCorrelationButton.Position = [402 194 98 23];
            app.autoCorrelationButton.Text = 'Load';

            % Create AutoLabel
            app.AutoLabel = uilabel(app.RandomProcessTab_2);
            app.AutoLabel.BackgroundColor = [0.902 0.902 0.902];
            app.AutoLabel.Position = [519 191 269 29];
            app.AutoLabel.Text = '';

            % Create LoadButton
            app.LoadButton = uibutton(app.RandomProcessTab_2, 'push');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.Position = [402 156 98 25];
            app.LoadButton.Text = 'Load';

            % Create sampleFunctionsLabel
            app.sampleFunctionsLabel = uilabel(app.RandomProcessTab_2);
            app.sampleFunctionsLabel.BackgroundColor = [0.902 0.902 0.902];
            app.sampleFunctionsLabel.FontSize = 14;
            app.sampleFunctionsLabel.Position = [518 154 269 29];
            app.sampleFunctionsLabel.Text = '';

            % Create TotalAveragePowerLabel
            app.TotalAveragePowerLabel = uilabel(app.RandomProcessTab_2);
            app.TotalAveragePowerLabel.FontSize = 14;
            app.TotalAveragePowerLabel.Position = [257 280 140 22];
            app.TotalAveragePowerLabel.Text = 'Total Average Power: ';

            % Create averagePowerLabel
            app.averagePowerLabel = uilabel(app.RandomProcessTab_2);
            app.averagePowerLabel.BackgroundColor = [0.902 0.902 0.902];
            app.averagePowerLabel.FontSize = 14;
            app.averagePowerLabel.Position = [396 277 225 28];
            app.averagePowerLabel.Text = '';

            % Create WattLabel
            app.WattLabel = uilabel(app.RandomProcessTab_2);
            app.WattLabel.FontSize = 14;
            app.WattLabel.Position = [630 277 33 22];
            app.WattLabel.Text = 'Watt';

            % Create PlotNnumberofsamplefunctionsLabel
            app.PlotNnumberofsamplefunctionsLabel = uilabel(app.RandomProcessTab_2);
            app.PlotNnumberofsamplefunctionsLabel.Position = [147 154 240 29];
            app.PlotNnumberofsamplefunctionsLabel.Text = 'Plot N number of sample functions';

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