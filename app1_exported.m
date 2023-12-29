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
        WattLabel                       matlab.ui.control.Label
        AutoLabel                       matlab.ui.control.Label
        timeMeanLabel                   matlab.ui.control.Label
        sampleFunctionsLabel            matlab.ui.control.Label
        fileInfo                        matlab.ui.control.Label
        Label_5                         matlab.ui.control.Label
        TotalAveragePowerLabel          matlab.ui.control.Label
        LOADPROCESSDATAFILESButton      matlab.ui.control.Button
        TimeMeanofnthsamplefunctionLabel_2  matlab.ui.control.Label
        AutocorrelationfunctionnthsamplefunctionLabel_2  matlab.ui.control.Label
        plotMnumberofsamplefunctionsLabel  matlab.ui.control.Label
        Label_4                         matlab.ui.control.Label
        timeMeanButton                  matlab.ui.control.Button
        autoCorrelationButton           matlab.ui.control.Button
        LoadButton_4                    matlab.ui.control.Button
        ensembleGraph                   matlab.ui.control.UIAxes
        sampleGraph                     matlab.ui.control.UIAxes
        spectralGraph                   matlab.ui.control.UIAxes
        autoGraph                       matlab.ui.control.UIAxes
        ContextMenu                     matlab.ui.container.ContextMenu
        Menu                            matlab.ui.container.Menu
        Menu2                           matlab.ui.container.Menu
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
                

                max_lag = 101;
                app.R_x = xcorr(mean(app.RPX, 1), max_lag, 'coeff');
                lag_values = -max_lag:max_lag;
                plot(app.autoGraph, lag_values, app.R_x);

                fs = 1 / (app.RPt(2) - app.RPt(1));
                psd = abs(fft(app.R_x)).^2 / N;
                freq = linspace(0, fs/2, length(psd));
                stem(app.spectralGraph, freq, 10*log10(psd));

            end

            
        end

        % Button pushed function: LoadButton_4
        function LoadButton_4Pushed(app, event)
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
                    cla(app.sampleGraph);
                
                    t = app.RPt;  
                    hold(app.sampleGraph, 'on');
                    for row = 1:app.SFM
                        plot(app.sampleGraph, t, app.RPX(row, :));
                    end
                    hold(app.sampleGraph, 'off');
                
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
                    cla(app.sampleGraph);
                    

                    %xlabel(app.sampleGraph, 'Time');
                    %ylabel(app.sampleGraph, 'Mean Amplitude');
                    %title(app.sampleGraph, ['Time Mean Function for Row ', num2str(app.SFn)]);
                    
                    %app.timeMeanLabel.Text = ['Plotted Time Mean Function for Row ', num2str(app.SFn)];
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
                    cla(app.sampleGraph);
%                    max_lag = 101;
%                    lag_values = -max_lag:max_lag;

%                   autocorrelation = xcorr(app.RPX(app.SFn2, :),max_lag, 'coeff');
%                   plot(app.sampleGraph, lag_values, autocorrelation);

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

            % Create autoGraph
            app.autoGraph = uiaxes(app.RandomProcessTab_2);
            title(app.autoGraph, 'auto-correlation function')
            xlabel(app.autoGraph, 'Time Delay (s)')
            ylabel(app.autoGraph, 'autocorrelation ')
            app.autoGraph.Position = [77 643 382 228];

            % Create spectralGraph
            app.spectralGraph = uiaxes(app.RandomProcessTab_2);
            title(app.spectralGraph, 'Power Spectral Density')
            xlabel(app.spectralGraph, 'Frequency (Hz)')
            ylabel(app.spectralGraph, 'Power\Frequency (Watt\Hz)')
            zlabel(app.spectralGraph, 'Z')
            app.spectralGraph.Position = [462 643 381 228];

            % Create sampleGraph
            app.sampleGraph = uiaxes(app.RandomProcessTab_2);
            title(app.sampleGraph, 'Sample Graph')
            xlabel(app.sampleGraph, 'T (s)')
            ylabel(app.sampleGraph, 'X')
            zlabel(app.sampleGraph, 'Z')
            app.sampleGraph.Position = [372 114 467 300];

            % Create ensembleGraph
            app.ensembleGraph = uiaxes(app.RandomProcessTab_2);
            title(app.ensembleGraph, 'Ensemble Mean')
            xlabel(app.ensembleGraph, 'X')
            ylabel(app.ensembleGraph, 'Y')
            zlabel(app.ensembleGraph, 'Z')
            app.ensembleGraph.Position = [79 416 768 228];

            % Create LoadButton_4
            app.LoadButton_4 = uibutton(app.RandomProcessTab_2, 'push');
            app.LoadButton_4.ButtonPushedFcn = createCallbackFcn(app, @LoadButton_4Pushed, true);
            app.LoadButton_4.Position = [81 327 103 23];
            app.LoadButton_4.Text = 'Load';

            % Create autoCorrelationButton
            app.autoCorrelationButton = uibutton(app.RandomProcessTab_2, 'push');
            app.autoCorrelationButton.ButtonPushedFcn = createCallbackFcn(app, @autoCorrelationButtonPushed, true);
            app.autoCorrelationButton.Position = [84 136 98 23];
            app.autoCorrelationButton.Text = 'Load';

            % Create timeMeanButton
            app.timeMeanButton = uibutton(app.RandomProcessTab_2, 'push');
            app.timeMeanButton.ButtonPushedFcn = createCallbackFcn(app, @timeMeanButtonPushed, true);
            app.timeMeanButton.Position = [81 237 107 23];
            app.timeMeanButton.Text = 'Load';

            % Create Label_4
            app.Label_4 = uilabel(app.RandomProcessTab_2);
            app.Label_4.Position = [1 784 2 2];

            % Create plotMnumberofsamplefunctionsLabel
            app.plotMnumberofsamplefunctionsLabel = uilabel(app.RandomProcessTab_2);
            app.plotMnumberofsamplefunctionsLabel.Position = [79 361 188 29];
            app.plotMnumberofsamplefunctionsLabel.Text = 'plot M number of sample functions';

            % Create AutocorrelationfunctionnthsamplefunctionLabel_2
            app.AutocorrelationfunctionnthsamplefunctionLabel_2 = uilabel(app.RandomProcessTab_2);
            app.AutocorrelationfunctionnthsamplefunctionLabel_2.Position = [81 184 240 29];
            app.AutocorrelationfunctionnthsamplefunctionLabel_2.Text = 'Autocorrelation function nth sample function';

            % Create TimeMeanofnthsamplefunctionLabel_2
            app.TimeMeanofnthsamplefunctionLabel_2 = uilabel(app.RandomProcessTab_2);
            app.TimeMeanofnthsamplefunctionLabel_2.Position = [81 272 240 29];
            app.TimeMeanofnthsamplefunctionLabel_2.Text = 'Time Mean of nth sample function';

            % Create LOADPROCESSDATAFILESButton
            app.LOADPROCESSDATAFILESButton = uibutton(app.RandomProcessTab_2, 'push');
            app.LOADPROCESSDATAFILESButton.ButtonPushedFcn = createCallbackFcn(app, @LOADPROCESSDATAFILESButtonPushed, true);
            app.LOADPROCESSDATAFILESButton.Position = [160 922 270 28];
            app.LOADPROCESSDATAFILESButton.Text = 'LOAD PROCESS DATA FILES';

            % Create TotalAveragePowerLabel
            app.TotalAveragePowerLabel = uilabel(app.RandomProcessTab_2);
            app.TotalAveragePowerLabel.FontSize = 14;
            app.TotalAveragePowerLabel.Position = [160 885 270 22];
            app.TotalAveragePowerLabel.Text = 'Total Average Power: ';

            % Create Label_5
            app.Label_5 = uilabel(app.RandomProcessTab_2);
            app.Label_5.BackgroundColor = [0.902 0.902 0.902];
            app.Label_5.FontSize = 14;
            app.Label_5.Position = [458 882 279 28];
            app.Label_5.Text = '';

            % Create fileInfo
            app.fileInfo = uilabel(app.RandomProcessTab_2);
            app.fileInfo.BackgroundColor = [0.902 0.902 0.902];
            app.fileInfo.FontSize = 14;
            app.fileInfo.Position = [458 922 356 28];
            app.fileInfo.Text = '';

            % Create sampleFunctionsLabel
            app.sampleFunctionsLabel = uilabel(app.RandomProcessTab_2);
            app.sampleFunctionsLabel.BackgroundColor = [0.902 0.902 0.902];
            app.sampleFunctionsLabel.Position = [192 321 176 29];
            app.sampleFunctionsLabel.Text = '';

            % Create timeMeanLabel
            app.timeMeanLabel = uilabel(app.RandomProcessTab_2);
            app.timeMeanLabel.BackgroundColor = [0.902 0.902 0.902];
            app.timeMeanLabel.Position = [192 234 176 29];
            app.timeMeanLabel.Text = '';

            % Create AutoLabel
            app.AutoLabel = uilabel(app.RandomProcessTab_2);
            app.AutoLabel.BackgroundColor = [0.902 0.902 0.902];
            app.AutoLabel.Position = [192 136 176 29];
            app.AutoLabel.Text = '';

            % Create WattLabel
            app.WattLabel = uilabel(app.RandomProcessTab_2);
            app.WattLabel.FontSize = 14;
            app.WattLabel.Position = [748 885 33 22];
            app.WattLabel.Text = 'Watt';

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.UIFigure);

            % Create Menu
            app.Menu = uimenu(app.ContextMenu);
            app.Menu.Text = 'Menu';

            % Create Menu2
            app.Menu2 = uimenu(app.ContextMenu);
            app.Menu2.Text = 'Menu2';
            
            % Assign app.ContextMenu
            app.LoadButton_4.ContextMenu = app.ContextMenu;

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