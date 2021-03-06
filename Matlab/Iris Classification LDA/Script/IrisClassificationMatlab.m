%================================================================
% Modul Klasifikasi Bunga Iris dengan Classifier Linear Disciminant Analysis
% Source: https://www.mathworks.com/help/stats/classification-example.html
%
% Author    : Bayu R. J. (bayujati50@gmail.com)
% Version   : 1.1
% Level     : Beginner, Intermediate
% Language  : Matlab
% Matlab    : MATLAB 2015b (pakai 'New Script' untuk membuat script baru)
%================================================================
% Changelog
%
% 16/10/2020 (1.0) - Script diselesaikan.
% 25/06/2021 (1.1) - Petals included.
%----------------------------------------------------------------
% Compatibility
%
% - Saya menggunakan MATLAB 2015b, sekiranya anda dapat mempertimbangkan
% untuk menggunakan MATLAB 2015b atau lebih baru. Kalau tidak, mungkin
% beberapa fungsi tidak bisa dijalankan/error.
%----------------------------------------------------------------
% Known Bugs and Issues
%
% - Tidak bisa menggunakan fungsi confusionchart(C). Dikarenakan fungsi
% tersebut baru diperkenalkan di MATLAB 2018b
% - Tidak bisa menampilkan error dari prediksi pengujian karena data
% sebenarnya tidak diketahui (Opsional).
%-----------------------------------------------------------------
% Introduction
%
%   Penggunaan script ini adalah untuk mengklasifikasikan bunga iris
% berdasarkan panjang dan lebar kelopak bunga (sepal), serta panjang dan lebar daun bunga (petal). 
% Sebetulnya ini banyak bertebaran di internet, tapi script ini menggunakan dataset kustom
% dari excel. Walaupun demikian, masih memiliki kesamaan dengan dataset
% Fisheriris karena referensinya dari situ.
%
%-----------------------------------------------------------------
% Inisialisasi
%-------------------
close all;                                      % Menutup semua jendela figure dan/atau pesan.
clear global;                                   % Membersihkan seluruh variabel.
clear IrisClassificationMatlab;                 % Membersihkan cache script ini.
clc;                                            % Membersihkan 'command window'.

% Deklarasi variabel
%------------------------------------------
trainI = readtable('C:\Users\Asus\Desktop\Lostsaga_screenshot\Iris Classification Matlab\Dataset\Dataset Iris.xlsx');        % Membaca file Excel jadi tabel.
SepLen = str2double(trainI.SepalLengthCm);      % Konversi nilai panjang sepal dari 'string' jadi 'double'.
SepWid = str2double(trainI.SepalWidthCm);       % Konversi nilai lebar sepal dari 'string' jadi 'double'.
PetLen = str2double(trainI.PetalLengthCm);
PetWid = str2double(trainI.PetalWidthCm);
%Sepal = [SepLen SepWid];                        % Menggabungkan jadi matriks baru.
Allin = [SepLen SepWid PetLen PetWid];
Spec = trainI.Species;                          % Deklarasi kategori spesies.

trainI2 = trainI(~any(ismissing(trainI(:,2:5)),2), :); % Tabel ke-2 hanya untuk menghilangkan angka yang kosong pada tabel.
Sep2Len = str2double(trainI2.SepalLengthCm);    % Konversi nilai panjang sepal dari 'string' jadi 'double'.
Sep2Wid = str2double(trainI2.SepalLengthCm);    % Konversi nilai lebar sepal dari 'string' jadi 'double'.
Pet2Len = str2double(trainI2.PetalLengthCm);
Pet2Wid = str2double(trainI2.PetalWidthCm);
%Sepal2 = [Sep2Len Sep2Wid];
Allin2 = [Sep2Len Sep2Wid Pet2Len Pet2Wid];     % Menggabungkan jadi matriks baru.
Spec2 = trainI2.Species;                        % Deklarasi kategori spesies kedua.



testI = readtable('C:\Users\Asus\Desktop\Lostsaga_screenshot\Iris Classification Matlab\Dataset\Data iris submission.xlsx'); % Tabel untuk data test (pengujian).
SepLenTest = str2double(testI.SepalLengthCm);   % Konversi nilai panjang sepal dari 'string' jadi 'double'.
SepWidTest = str2double(testI.SepalWidthCm);    % Konversi nilai lebar sepal dari 'string' jadi 'double'.
PetLenTest = str2double(testI.PetalLengthCm);
PetWidTest = str2double(testI.PetalWidthCm);
SepalTest = [SepLenTest SepWidTest]; % Menggabungkan jadi matriks baru.
AllinTest = [SepLenTest SepWidTest PetLenTest PetWidTest];

% Kenapa trainI ada 2?
% Karena trainI akan menghasilkan 135 baris, sedangkan trainI2 menghasilkan 127 baris.

% Membuat figur 1 yang berisi grafik dataset Sepal
%--------------------------------------------
f1 = figure;                                % Inisialisasi figur1.
gscatter(SepLen,SepWid,Spec,'rgb','osd');   % Membuat sebaran data grafik x, y, dan grup (rgb = warna, osd = bentuk).
xlabel('Sepal length');                     % Ini jelas.
ylabel('Sepal width');                      % Ini jelas.

% Membuat figur 2 yang berisi grafik dataset Petal
%--------------------------------------------
f2 = figure;                                % Inisialisasi figur1.
gscatter(PetLen,PetWid,Spec,'rgb','osd');   % Membuat sebaran data grafik x, y, dan grup (rgb = warna, osd = bentuk).
xlabel('Petal length');                     % Ini jelas.
ylabel('Petal width');                      % Ini jelas.

% Mulai training dengan fit LDA
%---------------------------------
lda = fitcdiscr(Allin, Spec);               % Training.
ldaClass = resubPredict(lda);               % Validasi prediksi.
% Hasil validasi berubah jadi 127 baris dari 135 baris. Penyebabnya karena
% ada beberapa cell yang kosong pada data set.


% Menghitung Error validasi (Hasil ada di command window).
%--------------------------------
ldaResubErr = resubLoss(lda);               
disp('Error validasi');
disp(ldaResubErr);

% Membuat confusion matriks
C1 = confusionmat(Spec2, ldaClass);
f3 = figure;
%ldaResubCM = confusionchart(C1); >>>>>> % Gak bisa, kudu 2018b. Kalo punya, hilangkan tanda '%'
imagesc(C1);                             % Menampilkan matriks dengan warna.
xlabel('Predicted');
ylabel('True Value');
colorbar;
disp(C1);

% Menampilkan poin mana saja yang salah prediksi pada sepal
%------------------------------------------------
figure(f1);
bad = ~strcmp(ldaClass,Spec2);                         % Membandingkan kelas (pake trainI2 karena cuma 127 baris).
hold on;
plot(SepLen(bad), SepWid(bad), 'kx');                  % Memberi tanda silang pada prediksi yang salah.
hold off;

% Menampilkan poin mana saja yang salah prediksi pada petal
%------------------------------------------------
figure(f2);
bad = ~strcmp(ldaClass,Spec2);                         % Membandingkan kelas (pake trainI2 karena cuma 127 baris).
hold on;
plot(PetLen(bad), PetWid(bad), 'kx');                  % Memberi tanda silang pada prediksi yang salah.
hold off;

% Prediksi data pengujian
[Diprediksi, score, cost] = predict(lda, AllinTest);   % Melakukan prediksi (penjelasan terpisah).
fprintf('Diprediksi: \n');
disp(Diprediksi); % Hasil prediksi yang merupakan label kelas bunga (misal: Iris-virginica).
fprintf('Score: \n');
disp('    setosa   versicolor    virginica') 
disp(score); % Nilai kecenderungan memilih dari classifier (semakin mendekati 1 maka ia akan dipilih kayak voting).
fprintf('Cost: \n');
disp('    setosa   versicolor    virginica')
disp(cost); % Nilai buangan dari pemilihan (sama kayak pemilih tidak setuju dalam voting)

Diprediksi2 = char(Diprediksi);
cntPred1 = strcmp(Diprediksi,'Iris-setosa');
cntPred2 = strcmp(Diprediksi,'Iris-versicolor');
cntPred3 = strcmp(Diprediksi,'Iris-virginica');
nnz(cntPred1);
nnz(cntPred2);
nnz(cntPred3);


T = table({'Iris-setosa';'Iris-versicolor';'Iris-virginica'},{nnz(cntPred1);nnz(cntPred2);nnz(cntPred3)});
T.Properties.VariableNames = {'Species', 'Predicted'};
T
%================================================
%
% End of Script
%
%================================================
