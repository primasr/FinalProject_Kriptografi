clear;

% terhubung ke tcp sebagai server
t = tcpip('127.0.0.1', 30000, 'NetworkRole', 'server');
fopen(t);

% read data
data = fread(t);

% ubah inputan ke bentuk char
data = char(data);

% ubah dari char ke string
data = convertCharsToStrings(data);

% ubah \n menjadi new line
data = compose(data);

% pecah menjadi beberapa baris berdasarkan new line
data = splitlines(data);

% declare variable
gambar_ori = data(1,1);
gambar_watermarked = data(2,1);

M=960;
N=120;
K=8;

A=imread(gambar_ori);
A=rgb2gray(A);
A=imresize(A,[960,960]);
b=imread(gambar_watermarked);

for p=1:N
    for q=1:N
        x=(p-1)*K+1;
        y=(q-1)*K+1;
        BLOCK1=A(x:x+K-1,y:y+K-1);
        BLOCK2=b(x:x+K-1,y:y+K-1);
        BLOCK1=idct2(BLOCK1);
        BLOCK2=idct2(BLOCK2);
            if BLOCK1(1,1)~=0
                a=(BLOCK2(1,1)/BLOCK1(1,1))-1;
                if a<0
                    W(p,q)=0;
                else
                    W(p,q)=1;
                end
            end
     end
end

subplot(2,2,1);
imshow(W);
title('Extracted Watermark Image');
imwrite(W,'de-watermarked.jpg','jpg');

% cek perbedaan watermark awal dan watermark hasil ekstrak
w_awal = imread('target.jpg');
w_akhir = imread('de-watermarked.jpg');
err = immse(w_awal, w_akhir);
fprintf('\n The mean-squared error is %0.4f\n', err);
