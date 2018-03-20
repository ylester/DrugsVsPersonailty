file = fopen('drug_consumption.csv');
% 13 Numerical
% 19 Categorical
% Convert csv file into cell array of all doubles
data = textscan(file, '%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f,CL%f');
fclose(file);
% Convert cell array to double array
data = cell2mat(data);
data = mapc(data, 2, [... % Convert age to int
    -0.95197, 0 ; ... % 0: 18-24
    -0.07854, 1 ; ... % 1: 25-34
    0.49788, 2 ; ...  % 2: 35-44
    1.09449, 3 ; ...  % 3: 45-54
    1.82213, 4 ; ...  % 4: 55-64
    2.59171, 5 ...    % 5: 65+
    ]);
data = mapc(data, 3, [... % Convert gender to int
    0.48246, 0 ; ...  % 0: Female
    -0.48246, 1 ; ... % 1: Male
    ]);
data = mapc(data, 4, [... % Convert education to int
    -2.43591, 0 ; ... % 0: Left school before 16 years
    -1.73790, 1 ; ... % 1: Left school at 16 years
    -1.43719, 2 ; ... % 2: Left school at 17 years
    -1.22751, 3 ; ... % 3: Left school at 18 years
    -0.61113, 4 ; ... % 4: Some college or university, no certificate or degree
    -0.05921, 5 ; ... % 5: Professional certificate/ diploma
    0.45468, 6 ; ...  % 6: University degree
    1.16365, 7 ; ...  % 7: Masters degree
    1.98437, 8 ...    % 8: Doctorate degree
    ]);
data = mapc(data, 5, [... % Convert country to int
    -0.09765, 0 ; ... % 0: Australia
    0.24923, 1 ; ...  % 1: Canada
    -0.46841, 2 ; ... % 2: New Zealand
    -0.28519, 3 ; ... % 3: Other
    0.21128, 4 ; ...  % 4: Republic of Ireland
    0.96082, 5 ; ...  % 5: UK
    -0.57009, 6 ...   % 6: USA
    ]);
data = mapc(data, 6, [... % Convert ethnicity to int
    -0.50212, 0 ; ... % 0: Asian
    -1.10702, 1 ; ... % 1: Black
    1.90725, 2 ; ...  % 2: Mixed-Black/Asian
    0.12600, 3 ; ...  % 3: Mixed-White/Asian
    -0.22166, 4 ; ... % 4: Mixed-White/Black
    0.11440, 5 ; ...  % 5: Other
    -0.31685, 6 ...   % 6: White
    ]);
% Convert columns 7-13 to 0..1 by normalizing
for i = 7:13
    data = normc(data, i);
end
 
data_names = { ...
    'id', ...           % 1 ID (Int 1-1885) is number of record in original database
    'age', ...          % 2 Age (Int 0-5) is age of participant
    'gender', ...       % 3 Gender (Int 0-1) is gender of participant
    'education', ...    % 4 Education (Int 0-8) is level of education of participant 
    'country', ...      % 5 Country (Int 0-6) is country of current residence of participant 
    'ethnicity', ...    % 6 Ethnicity (Int 0-6) is ethnicity of participant
    'nscore', ...       % 7 Nscore (Real 0.0-1.0) is NEO-FFI-R Neuroticism
    'escore', ...       % 8 Escore (Real 0.0-1.0) is NEO-FFI-R Extraversion
    'oscore', ...       % 9 Oscore (Real 0.0-1.0) is NEO-FFI-R Openness to experience
    'ascore', ...       % 10 Ascore (Real 0.0-1.0) is NEO-FFI-R Agreeableness
    'cscore', ...       % 11 Cscore (Real 0.0-1.0) is NEO-FFI-R Conscientiousness
    'impulsive', ...    % 12 Impulsive (Real 0.0-1.0) is impulsiveness measured by BIS-11
    'ss', ...           % 13 SS (Real 0.0-1.0) is sensation seeing measured by ImpSS
    'alcohol', ...      % 14 Alcohol is class of alcohol consumption
    'amphet', ...       % 15 Amphet is class of amphetamines consumption
    'amyl', ...         % 16 Amyl is class of amyl nitrite consumption
    'benzos', ...       % 17 Benzos is class of benzodiazepine consumption
    'caff', ...         % 18 Caff is class of caffeine consumption
    'cannabis', ...     % 19 Cannabis is class of cannabis consumption
    'choc', ...         % 20 Choc is class of chocolate consumption
    'coke', ...         % 21 Coke is class of cocaine consumption
    'crack', ...        % 22 Crack is class of crack consumption
    'ecstasy', ...      % 23 Ecstasy is class of ecstasy consumption
    'heroin', ...       % 24 Heroin is class of heroin consumption
    'ketamine', ...     % 25 Ketamine is class of ketamine consumption
    'legalh', ...       % 26 Legalh is class of legal highs consumption
    'lsd', ...          % 27 LSD is class of alcohol consumption
    'meth', ...         % 28 Meth is class of methadone consumption
    'mushrooms', ...    % 29 Mushrooms is class of magic mushrooms consumption
    'nicotine', ...     % 30 Nicotine is class of nicotine consumption
    'semer', ...        % 31 Semer is class of fictitious drug Semeron consumption
    'vsa', ...          % 32 VSA is class of volatile substance abuse consumption
    };

% Columns 14-32 (Last use of drug c at time of sample) Key
% 0: Never Used
% 1: Used over a Decade Ago
% 2: Used in Last Decade
% 3: Used in Last Year
% 4: Used in Last Month
% 5: Used in Last Week
% 6: Used in Last Day

class_names = { 'Never Used', ...
                'Used over a Decade Ago', ...
                'Used in Last Decade', ...
                'Used in Last Year', ...
                'Used in Last Month', ...
                'Used in Last Week', ...
                'Used in Last Day' };
            
% Cells for all other columns that can be mapped to names
% For ease of use only, E.g. age = 0; name = age_names{1, age+1};
            
age_names = { '18-24', ...
              '25-34', ...
              '35-44', ...
              '45-54', ...
              '55-64', ...
              '65+' };
           
gender_names = { 'Female', ...
                 'Male' };

education_names = { '< 16 years', ...
                    '= 16 years', ...
                    '= 17 years', ...
                    '= 18 years', ...
                    'Some college', ...
                    'Diploma', ...
                    'Unv. Degree', ...
                    'Mas. degree', ...
                    'Doc. degree' };
           
country_names = { 'Australia', ...
                  'Canada', ...
                  'New Zealand', ...
                  'Other', ...
                  'Republic of Ireland', ...
                  'UK', ...
                  'USA' };
  
ethnicity_names = { 'Asian', ...
                    'Black', ...
                    'Mixed-Black/Asian', ...
                    'Mixed-White/Asian', ...
                    'Mixed-White/Black', ...
                    'Other', ...
                    'White' };
