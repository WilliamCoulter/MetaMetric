function saveMyDefaults(app)
    %write values to myDefaults before saving
    myDefaults = [];
    save('MyAppDefaultValues.mat','myDefaults');
end

