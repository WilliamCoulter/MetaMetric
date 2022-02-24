function saveMyDefaults(app,event)
    %write values to myDefaults before saving
    %% Values as app closes
    myDefaults.userImportedTable = app.userImportedTable;
    %%
    save('MyAppDefaultValues.mat','myDefaults');
end

