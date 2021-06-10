% membersihkan layar
clc;
clear;
close all;

% define ukuran target
M=960;
N=120;

% define ukuran blok
K=8;

% membuat array kosongan dengan ukuran yang telah didefinisikan
I=zeros(M,M);
J=zeros(N,N);
BLOCK=zeros(K,K);

% Processing gambar source
subplot(1,3,1); % posisi gambar ditampilkan pada Figure nantinya
I=imread('lena.jpg'); % read gambar
I=rgb2gray(I); % mengubah gambar dari rgb -> gray
I=imresize(I,[960,960]); % resize ukuran
imwrite(I,'source.jpg','jpg'); % menyimpan gambar

% menampilkan gambar pada Figure
imshow(I);
title('Source Image');

% Processing gambar watermark
subplot(1,3,2);
J=imread('w.jpg');
J=imbinarize(J,0.4); % membuat binary image dari nilai threshold gambar
J=imresize(J,[120,120]);
imwrite(J,'target.jpg','jpg');
imshow(J);
title('Watermark Image');

% loop sebanyak blok (dalam kasus ini 8x8)
for p=1:N
    for q=1:N
        x=(p-1)*K+1;
        y=(q-1)*K+1;
        BLOCK=I(x:x+K-1,y:y+K-1);
        BLOCK=dct2(BLOCK);
        if J(p,q)==0
            a=-1;
        else
            a=1;
        end
    %multiplicative watermarking algorithm factor
    BLOCK=BLOCK*(1+a*0.03);
    BLOCK=idct2(BLOCK);
    I(x:x+K-1,y:y+K-1)=BLOCK;
    end
end

% Processing gambar hasil
subplot(1,3,3);
imshow(I);
title('Image Result');
imwrite(I,'watermarked.jpg','jpg');
