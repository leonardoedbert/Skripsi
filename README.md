# Evaluasi Metode Spiral Dynamic Optimization pada Hyperparameter Tuning Model XGBoost untuk Prediksi Tinggi Gelombang Laut

## Deskripsi Proyek

Proyek ini merupakan implementasi dari penelitian skripsi yang berfokus pada evaluasi metode **Spiral Dynamic Optimization (SDO)** untuk melakukan **hyperparameter tuning** pada model **XGBoost** dalam tugas prediksi tinggi gelombang laut.

Tujuan utama penelitian ini adalah meningkatkan performa model prediksi dengan menemukan kombinasi hyperparameter yang optimal menggunakan metode optimasi berbasis spiral.

## Latar Belakang

Prediksi tinggi gelombang laut merupakan masalah penting dalam bidang kelautan, navigasi, serta mitigasi risiko maritim. Model machine learning seperti XGBoost memiliki performa yang baik untuk tugas prediksi, namun sangat bergantung pada pemilihan hyperparameter yang tepat.

Metode optimasi seperti Spiral Dynamic Optimization digunakan untuk mencari kombinasi hyperparameter secara lebih efisien dibandingkan metode pencarian konvensional.

## Tujuan Penelitian

1. Mengimplementasikan algoritma Spiral Dynamic Optimization untuk proses hyperparameter tuning.
2. Mengoptimalkan hyperparameter model XGBoost.
3. Mengevaluasi performa model dalam prediksi tinggi gelombang laut.
4. Membandingkan hasil performa model sebelum dan sesudah proses optimasi.

## Metodologi

Tahapan utama dalam proyek ini meliputi:

1. **Pengumpulan dan pemrosesan data**
2. **Pembangunan model baseline XGBoost**
3. **Implementasi algoritma Spiral Dynamic Optimization**
4. **Proses hyperparameter tuning pada dimensi 2–9 hyperparameter**
5. **Evaluasi performa model**

## Struktur Proyek

```
project-root
│
├── data
│   └── dataset.csv
│
├── notebooks
│   └── experiment.ipynb
│
├── src
│   ├── sdo_optimizer.py
│   └── train_model.py
│
├── results
│   └── experiment_results.csv
│
├── requirements.txt
└── README.md
```

## Penjelasan Folder

**data/**
Berisi dataset yang digunakan dalam penelitian.

**notebooks/**
Notebook untuk eksplorasi data, eksperimen model, dan visualisasi hasil.

**src/**
Implementasi algoritma utama termasuk Spiral Dynamic Optimization dan proses training model.

**results/**
Berisi hasil eksperimen seperti nilai evaluasi model dan perbandingan metode.

## Hyperparameter yang Dioptimasi

Contoh hyperparameter yang dapat dioptimasi dalam penelitian ini antara lain:

* learning_rate
* max_depth
* n_estimators
* subsample
* colsample_bytree

Jumlah dimensi hyperparameter yang diuji berada pada rentang **2 hingga 9 parameter**.

## Metode Evaluasi

Performa model dievaluasi menggunakan metrik evaluasi regresi seperti:

* Mean Squared Error (MSE)
* Root Mean Squared Error (RMSE)
* Mean Absolute Error (MAE)

## Cara Menjalankan Proyek

1. Clone repository

```
git clone https://github.com/username/repository-name.git
```

2. Install dependencies

```
pip install -r requirements.txt
```

3. Jalankan eksperimen

```
python src/train_model.py
```

atau menggunakan notebook

```
jupyter notebook notebooks/experiment.ipynb
```

## Hasil yang Diharapkan

* Model XGBoost dengan hyperparameter yang telah dioptimasi
* Peningkatan performa prediksi dibandingkan model baseline
* Analisis efektivitas metode Spiral Dynamic Optimization dalam proses hyperparameter tuning

## Kontribusi

Proyek ini dibuat sebagai bagian dari penelitian skripsi pada program studi matematika dengan fokus pada optimasi dan machine learning.

## Lisensi

Proyek ini digunakan untuk tujuan akademik dan penelitian.
