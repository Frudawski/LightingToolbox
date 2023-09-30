% RUN LIGHTING TOOLBOX TESTS

% list of tests
test_list = dir('./Toolbox_tests');

% loop over test list
for test_item = 1:length(test_list)
    % check for valid test file
    if contains(test_list(test_item).name,'LT_test_')
        runtests(test_list(test_item).name)
    end
end