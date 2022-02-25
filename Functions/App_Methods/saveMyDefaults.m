function saveMyDefaults(app,event)
    myDefaultsFile = [];
%     myDefaultsFile = app.myDefaults; %always make new default structure
    %write values to myDefaults before saving
    %% Values as app closes
    myDefaults.UITable_ImportedFile = app.UITable_ImportedFile;
    %%
    save('MyAppDefaults.mat','myDefaults');
end

