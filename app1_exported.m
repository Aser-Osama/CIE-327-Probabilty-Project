classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        RandomVariableTab               matlab.ui.container.Tab
        ExpParam2Label_2                matlab.ui.control.Label
        ExpParam1Label_2                matlab.ui.control.Label
        ExpParam2_2                     matlab.ui.control.NumericEditField
        LowerLimit                      matlab.ui.control.NumericEditField
        SampleFile                      matlab.ui.control.EditField
        RunRandomVariableButton         matlab.ui.control.Button
        ImportRandomVariableButton      matlab.ui.control.Button
        MeanValueLabel                  matlab.ui.control.Label
        RandomVariableMeanLabel         matlab.ui.control.Label
        ThirdMomentValueLabel           matlab.ui.control.Label
        RandomVariableThirdMomentLabel  matlab.ui.control.Label
        VarianceValueLabel              matlab.ui.control.Label
        RandomVariableVarianceLabel     matlab.ui.control.Label
        Label_2                         matlab.ui.control.Label
        Label                           matlab.ui.control.Label
        AserOsamaLabel                  matlab.ui.control.Label
        SaifeldenMohamedLabel           matlab.ui.control.Label
        ExperimenttypeDropDown          matlab.ui.control.DropDown
        ExperimenttypeDropDownLabel     matlab.ui.control.Label
        RandomVariableLabel             matlab.ui.control.Label
        CIE327ProjectLabel              matlab.ui.control.Label
        InvalidSampleFileWarning        matlab.ui.control.Label
        GarbageLabel                    matlab.ui.control.Label
        ExpParam2Label                  matlab.ui.control.Label
        ExpParam1Label                  matlab.ui.control.Label
        ExpParam2                       matlab.ui.control.NumericEditField
        ExpParam1                       matlab.ui.control.NumericEditField
        SecMoment_2                     matlab.ui.control.UIAxes
        FirMoment_2                     matlab.ui.control.UIAxes
        mgf_2                           matlab.ui.control.UIAxes
        RandomProcessTab_2              matlab.ui.container.Tab
        LOADTIMEFILEButton              matlab.ui.control.Button
        LOADPROCESSDATAFILESButton      matlab.ui.control.Button
        TotalAveragePowerEditField      matlab.ui.control.NumericEditField
        TotalAveragePowerEditFieldLabel  matlab.ui.control.Label
        TimeMeanofnthsamplefunctionLabel_2  matlab.ui.control.Label
        AutocorrelationfunctionnthsamplefunctionLabel_2  matlab.ui.control.Label
        NumberofSamplefunctionsLabel_2  matlab.ui.control.Label
        Label_4                         matlab.ui.control.Label
        LoadButton_6                    matlab.ui.control.Button
        LoadButton_5                    matlab.ui.control.Button
        LoadButton_4                    matlab.ui.control.Button
        nEditField_4                    matlab.ui.control.NumericEditField
        nEditField_4Label               matlab.ui.control.Label
        nEditField_3                    matlab.ui.control.NumericEditField
        nEditField_3Label               matlab.ui.control.Label
        MEditField_2                    matlab.ui.control.NumericEditField
        MEditField_2Label               matlab.ui.control.Label
        UIAxes_7                        matlab.ui.control.UIAxes
        UIAxes_6                        matlab.ui.control.UIAxes
        UIAxes_5                        matlab.ui.control.UIAxes
        UIAxes_4                        matlab.ui.control.UIAxes
        LoadDataTab                     matlab.ui.container.Tab
    end


    properties (Access = private)
        MyFilePath % Description
        SampleData % Description
        CanRun = 0
        ExpType = "uniform" % Description
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
            app.TabGroup.Position = [1 1 892 910];

            % Create RandomVariableTab
            app.RandomVariableTab = uitab(app.TabGroup);
            app.RandomVariableTab.Title = 'Random Variable';

            % Create mgf_2
            app.mgf_2 = uiaxes(app.RandomVariableTab);
            title(app.mgf_2, 'MGF')
            xlabel(app.mgf_2, 'X')
            ylabel(app.mgf_2, 'Y')
            zlabel(app.mgf_2, 'Z')
            app.mgf_2.Position = [8 542 422 236];

            % Create FirMoment_2
            app.FirMoment_2 = uiaxes(app.RandomVariableTab);
            title(app.FirMoment_2, 'First Moment')
            xlabel(app.FirMoment_2, 'X')
            ylabel(app.FirMoment_2, 'Y')
            zlabel(app.FirMoment_2, 'Z')
            app.FirMoment_2.Position = [7 297 423 237];

            % Create SecMoment_2
            app.SecMoment_2 = uiaxes(app.RandomVariableTab);
            title(app.SecMoment_2, 'Secont Moment')
            xlabel(app.SecMoment_2, 'X')
            ylabel(app.SecMoment_2, 'Y')
            zlabel(app.SecMoment_2, 'Z')
            app.SecMoment_2.Position = [8 46 423 237];

            % Create ExpParam1
            app.ExpParam1 = uieditfield(app.RandomVariableTab, 'numeric');
            app.ExpParam1.FontSize = 14;
            app.ExpParam1.Position = [562 187 65 22];

            % Create ExpParam2
            app.ExpParam2 = uieditfield(app.RandomVariableTab, 'numeric');
            app.ExpParam2.FontSize = 14;
            app.ExpParam2.Position = [788 184 65 22];

            % Create ExpParam1Label
            app.ExpParam1Label = uilabel(app.RandomVariableTab);
            app.ExpParam1Label.HorizontalAlignment = 'right';
            app.ExpParam1Label.FontSize = 14;
            app.ExpParam1Label.Position = [481 187 79 22];
            app.ExpParam1Label.Text = 'A (Start)';

            % Create ExpParam2Label
            app.ExpParam2Label = uilabel(app.RandomVariableTab);
            app.ExpParam2Label.HorizontalAlignment = 'right';
            app.ExpParam2Label.FontSize = 14;
            app.ExpParam2Label.Position = [659 184 126 22];
            app.ExpParam2Label.Text = 'B (End)';

            % Create GarbageLabel
            app.GarbageLabel = uilabel(app.RandomVariableTab);
            app.GarbageLabel.BackgroundColor = [1 0 0];
            app.GarbageLabel.FontSize = 36;
            app.GarbageLabel.Position = [529 612 145 47];
            app.GarbageLabel.Text = 'Garbage';

            % Create InvalidSampleFileWarning
            app.InvalidSampleFileWarning = uilabel(app.RandomVariableTab);
            app.InvalidSampleFileWarning.VerticalAlignment = 'bottom';
            app.InvalidSampleFileWarning.WordWrap = 'on';
            app.InvalidSampleFileWarning.FontSize = 14;
            app.InvalidSampleFileWarning.FontColor = [1 0 0];
            app.InvalidSampleFileWarning.Position = [35 792 348 59];
            app.InvalidSampleFileWarning.Text = '';

            % Create CIE327ProjectLabel
            app.CIE327ProjectLabel = uilabel(app.RandomVariableTab);
            app.CIE327ProjectLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.CIE327ProjectLabel.HorizontalAlignment = 'center';
            app.CIE327ProjectLabel.FontSize = 48;
            app.CIE327ProjectLabel.FontWeight = 'bold';
            app.CIE327ProjectLabel.Position = [477 805 373 62];
            app.CIE327ProjectLabel.Text = 'CIE 327 Project';

            % Create RandomVariableLabel
            app.RandomVariableLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableLabel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.RandomVariableLabel.HorizontalAlignment = 'center';
            app.RandomVariableLabel.FontSize = 24;
            app.RandomVariableLabel.FontWeight = 'bold';
            app.RandomVariableLabel.Position = [475 775 376 31];
            app.RandomVariableLabel.Text = 'Random Variable';

            % Create ExperimenttypeDropDownLabel
            app.ExperimenttypeDropDownLabel = uilabel(app.RandomVariableTab);
            app.ExperimenttypeDropDownLabel.HorizontalAlignment = 'right';
            app.ExperimenttypeDropDownLabel.FontSize = 14;
            app.ExperimenttypeDropDownLabel.Position = [481 155 106 22];
            app.ExperimenttypeDropDownLabel.Text = 'Experiment type';

            % Create ExperimenttypeDropDown
            app.ExperimenttypeDropDown = uidropdown(app.RandomVariableTab);
            app.ExperimenttypeDropDown.Items = {'File Input', 'Normal Distribution', 'Uniform Distribution'};
            app.ExperimenttypeDropDown.ValueChangedFcn = createCallbackFcn(app, @ExperimenttypeDropDownValueChanged, true);
            app.ExperimenttypeDropDown.FontSize = 14;
            app.ExperimenttypeDropDown.Position = [629 155 224 22];
            app.ExperimenttypeDropDown.Value = 'File Input';

            % Create SaifeldenMohamedLabel
            app.SaifeldenMohamedLabel = uilabel(app.RandomVariableTab);
            app.SaifeldenMohamedLabel.FontSize = 22;
            app.SaifeldenMohamedLabel.FontWeight = 'bold';
            app.SaifeldenMohamedLabel.Position = [458 717 234 47];
            app.SaifeldenMohamedLabel.Text = 'Saifelden Mohamed ';

            % Create AserOsamaLabel
            app.AserOsamaLabel = uilabel(app.RandomVariableTab);
            app.AserOsamaLabel.FontSize = 22;
            app.AserOsamaLabel.FontWeight = 'bold';
            app.AserOsamaLabel.Position = [458 691 202 37];
            app.AserOsamaLabel.Text = 'Aser Osama';

            % Create Label
            app.Label = uilabel(app.RandomVariableTab);
            app.Label.HorizontalAlignment = 'right';
            app.Label.FontSize = 22;
            app.Label.FontWeight = 'bold';
            app.Label.Position = [680 717 171 47];
            app.Label.Text = '202100432';

            % Create Label_2
            app.Label_2 = uilabel(app.RandomVariableTab);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.FontSize = 22;
            app.Label_2.FontWeight = 'bold';
            app.Label_2.Position = [670 690 181 37];
            app.Label_2.Text = '202101266';

            % Create RandomVariableVarianceLabel
            app.RandomVariableVarianceLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableVarianceLabel.FontSize = 18;
            app.RandomVariableVarianceLabel.FontWeight = 'bold';
            app.RandomVariableVarianceLabel.Position = [479 433 371 27];
            app.RandomVariableVarianceLabel.Text = 'Random Variable Variance:';

            % Create VarianceValueLabel
            app.VarianceValueLabel = uilabel(app.RandomVariableTab);
            app.VarianceValueLabel.BackgroundColor = [0.8 0.8 0.8];
            app.VarianceValueLabel.HorizontalAlignment = 'center';
            app.VarianceValueLabel.FontWeight = 'bold';
            app.VarianceValueLabel.FontColor = [0.502 0.502 0.502];
            app.VarianceValueLabel.Position = [477 397 373 37];
            app.VarianceValueLabel.Text = 'VarianceValue';

            % Create RandomVariableThirdMomentLabel
            app.RandomVariableThirdMomentLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableThirdMomentLabel.FontSize = 18;
            app.RandomVariableThirdMomentLabel.FontWeight = 'bold';
            app.RandomVariableThirdMomentLabel.Position = [479 308 371 27];
            app.RandomVariableThirdMomentLabel.Text = 'Random Variable Third Moment:';

            % Create ThirdMomentValueLabel
            app.ThirdMomentValueLabel = uilabel(app.RandomVariableTab);
            app.ThirdMomentValueLabel.BackgroundColor = [0.8 0.8 0.8];
            app.ThirdMomentValueLabel.HorizontalAlignment = 'center';
            app.ThirdMomentValueLabel.FontWeight = 'bold';
            app.ThirdMomentValueLabel.FontColor = [0.502 0.502 0.502];
            app.ThirdMomentValueLabel.Position = [479 272 371 37];
            app.ThirdMomentValueLabel.Text = 'ThirdMomentValue';

            % Create RandomVariableMeanLabel
            app.RandomVariableMeanLabel = uilabel(app.RandomVariableTab);
            app.RandomVariableMeanLabel.FontSize = 18;
            app.RandomVariableMeanLabel.FontWeight = 'bold';
            app.RandomVariableMeanLabel.Position = [477 549 373 27];
            app.RandomVariableMeanLabel.Text = 'Random Variable Mean:';

            % Create MeanValueLabel
            app.MeanValueLabel = uilabel(app.RandomVariableTab);
            app.MeanValueLabel.BackgroundColor = [0.8 0.8 0.8];
            app.MeanValueLabel.HorizontalAlignment = 'center';
            app.MeanValueLabel.FontWeight = 'bold';
            app.MeanValueLabel.FontColor = [0.502 0.502 0.502];
            app.MeanValueLabel.Position = [477 513 373 37];
            app.MeanValueLabel.Text = 'MeanValue';

            % Create ImportRandomVariableButton
            app.ImportRandomVariableButton = uibutton(app.RandomVariableTab, 'push');
            app.ImportRandomVariableButton.ButtonPushedFcn = createCallbackFcn(app, @ImportRandomVariableButtonPushed, true);
            app.ImportRandomVariableButton.BackgroundColor = [0.902 0.902 0.902];
            app.ImportRandomVariableButton.FontSize = 14;
            app.ImportRandomVariableButton.FontWeight = 'bold';
            app.ImportRandomVariableButton.Position = [750 25 100 62];
            app.ImportRandomVariableButton.Text = {'Import '; 'Random'; 'Variable'};

            % Create RunRandomVariableButton
            app.RunRandomVariableButton = uibutton(app.RandomVariableTab, 'push');
            app.RunRandomVariableButton.ButtonPushedFcn = createCallbackFcn(app, @RunRandomVariableButtonPushed, true);
            app.RunRandomVariableButton.FontWeight = 'bold';
            app.RunRandomVariableButton.Position = [475 96 373 34];
            app.RunRandomVariableButton.Text = 'Run Random Variable';

            % Create SampleFile
            app.SampleFile = uieditfield(app.RandomVariableTab, 'text');
            app.SampleFile.HorizontalAlignment = 'center';
            app.SampleFile.Placeholder = 'EnterSampleFile.m';
            app.SampleFile.Position = [478 22 258 61];

            % Create LowerLimit
            app.LowerLimit = uieditfield(app.RandomVariableTab, 'numeric');
            app.LowerLimit.FontSize = 14;
            app.LowerLimit.Position = [562 218 65 22];

            % Create ExpParam2_2
            app.ExpParam2_2 = uieditfield(app.RandomVariableTab, 'numeric');
            app.ExpParam2_2.FontSize = 14;
            app.ExpParam2_2.Position = [788 215 65 22];
            app.ExpParam2_2.Value = 100;

            % Create ExpParam1Label_2
            app.ExpParam1Label_2 = uilabel(app.RandomVariableTab);
            app.ExpParam1Label_2.HorizontalAlignment = 'right';
            app.ExpParam1Label_2.FontSize = 14;
            app.ExpParam1Label_2.Position = [481 218 79 22];
            app.ExpParam1Label_2.Text = 'Lower Limit';

            % Create ExpParam2Label_2
            app.ExpParam2Label_2 = uilabel(app.RandomVariableTab);
            app.ExpParam2Label_2.HorizontalAlignment = 'right';
            app.ExpParam2Label_2.FontSize = 14;
            app.ExpParam2Label_2.Position = [659 215 126 22];
            app.ExpParam2Label_2.Text = 'Upper Limit';

            % Create RandomProcessTab_2
            app.RandomProcessTab_2 = uitab(app.TabGroup);
            app.RandomProcessTab_2.Title = 'Random Process';

            % Create UIAxes_4
            app.UIAxes_4 = uiaxes(app.RandomProcessTab_2);
            title(app.UIAxes_4, 'auto-correlation function')
            xlabel(app.UIAxes_4, 'X')
            ylabel(app.UIAxes_4, 'Y')
            zlabel(app.UIAxes_4, 'Z')
            app.UIAxes_4.Position = [77 549 376 228];

            % Create UIAxes_5
            app.UIAxes_5 = uiaxes(app.RandomProcessTab_2);
            title(app.UIAxes_5, 'Power Spectral Density')
            xlabel(app.UIAxes_5, 'X')
            ylabel(app.UIAxes_5, 'Y')
            zlabel(app.UIAxes_5, 'Z')
            app.UIAxes_5.Position = [463 549 376 228];

            % Create UIAxes_6
            app.UIAxes_6 = uiaxes(app.RandomProcessTab_2);
            title(app.UIAxes_6, 'Sample Graph')
            xlabel(app.UIAxes_6, 'X')
            ylabel(app.UIAxes_6, 'Y')
            zlabel(app.UIAxes_6, 'Z')
            app.UIAxes_6.Position = [383 2 467 283];

            % Create UIAxes_7
            app.UIAxes_7 = uiaxes(app.RandomProcessTab_2);
            title(app.UIAxes_7, 'Ensemble Mean')
            xlabel(app.UIAxes_7, 'X')
            ylabel(app.UIAxes_7, 'Y')
            zlabel(app.UIAxes_7, 'Z')
            app.UIAxes_7.Position = [73 302 768 228];

            % Create MEditField_2Label
            app.MEditField_2Label = uilabel(app.RandomProcessTab_2);
            app.MEditField_2Label.HorizontalAlignment = 'right';
            app.MEditField_2Label.Position = [76 205 25 22];
            app.MEditField_2Label.Text = 'M';

            % Create MEditField_2
            app.MEditField_2 = uieditfield(app.RandomProcessTab_2, 'numeric');
            app.MEditField_2.Position = [116 205 110 22];

            % Create nEditField_3Label
            app.nEditField_3Label = uilabel(app.RandomProcessTab_2);
            app.nEditField_3Label.HorizontalAlignment = 'right';
            app.nEditField_3Label.Position = [77 33 25 22];
            app.nEditField_3Label.Text = 'n';

            % Create nEditField_3
            app.nEditField_3 = uieditfield(app.RandomProcessTab_2, 'numeric');
            app.nEditField_3.Position = [118 34 100 22];

            % Create nEditField_4Label
            app.nEditField_4Label = uilabel(app.RandomProcessTab_2);
            app.nEditField_4Label.HorizontalAlignment = 'right';
            app.nEditField_4Label.Position = [79 118 25 22];
            app.nEditField_4Label.Text = 'n';

            % Create nEditField_4
            app.nEditField_4 = uieditfield(app.RandomProcessTab_2, 'numeric');
            app.nEditField_4.Position = [119 118 100 22];

            % Create LoadButton_4
            app.LoadButton_4 = uibutton(app.RandomProcessTab_2, 'push');
            app.LoadButton_4.Position = [237 204 103 23];
            app.LoadButton_4.Text = 'Load';

            % Create LoadButton_5
            app.LoadButton_5 = uibutton(app.RandomProcessTab_2, 'push');
            app.LoadButton_5.Position = [240 33 98 23];
            app.LoadButton_5.Text = 'Load';

            % Create LoadButton_6
            app.LoadButton_6 = uibutton(app.RandomProcessTab_2, 'push');
            app.LoadButton_6.Position = [240 117 107 23];
            app.LoadButton_6.Text = 'Load';

            % Create Label_4
            app.Label_4 = uilabel(app.RandomProcessTab_2);
            app.Label_4.Position = [1 690 2 2];

            % Create NumberofSamplefunctionsLabel_2
            app.NumberofSamplefunctionsLabel_2 = uilabel(app.RandomProcessTab_2);
            app.NumberofSamplefunctionsLabel_2.Position = [87 235 156 29];
            app.NumberofSamplefunctionsLabel_2.Text = 'Number of Sample functions';

            % Create AutocorrelationfunctionnthsamplefunctionLabel_2
            app.AutocorrelationfunctionnthsamplefunctionLabel_2 = uilabel(app.RandomProcessTab_2);
            app.AutocorrelationfunctionnthsamplefunctionLabel_2.Position = [89 58 240 29];
            app.AutocorrelationfunctionnthsamplefunctionLabel_2.Text = 'Autocorrelation function nth sample function';

            % Create TimeMeanofnthsamplefunctionLabel_2
            app.TimeMeanofnthsamplefunctionLabel_2 = uilabel(app.RandomProcessTab_2);
            app.TimeMeanofnthsamplefunctionLabel_2.Position = [89 146 240 29];
            app.TimeMeanofnthsamplefunctionLabel_2.Text = 'Time Mean of nth sample function';

            % Create TotalAveragePowerEditFieldLabel
            app.TotalAveragePowerEditFieldLabel = uilabel(app.RandomProcessTab_2);
            app.TotalAveragePowerEditFieldLabel.HorizontalAlignment = 'right';
            app.TotalAveragePowerEditFieldLabel.Position = [475 809 115 22];
            app.TotalAveragePowerEditFieldLabel.Text = 'Total Average Power';

            % Create TotalAveragePowerEditField
            app.TotalAveragePowerEditField = uieditfield(app.RandomProcessTab_2, 'numeric');
            app.TotalAveragePowerEditField.Position = [615 809 227 22];

            % Create LOADPROCESSDATAFILESButton
            app.LOADPROCESSDATAFILESButton = uibutton(app.RandomProcessTab_2, 'push');
            app.LOADPROCESSDATAFILESButton.Position = [273 792 179 56];
            app.LOADPROCESSDATAFILESButton.Text = 'LOAD PROCESS DATA FILES';

            % Create LOADTIMEFILEButton
            app.LOADTIMEFILEButton = uibutton(app.RandomProcessTab_2, 'push');
            app.LOADTIMEFILEButton.Position = [78 791 151 56];
            app.LOADTIMEFILEButton.Text = 'LOAD TIME FILE';

            % Create LoadDataTab
            app.LoadDataTab = uitab(app.TabGroup);
            app.LoadDataTab.Title = 'Load Data';

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