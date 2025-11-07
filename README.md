# Neural-Signal-Dynamics
This project investigates how the brain encodes and processes sensory information through the analysis of electrophysiological recordings. It focuses on understanding neural activity at both the single-neuron and population levels using modern computational and information-theoretic methods.

---

## 📘 Overview

The project investigates **electrophysiological recordings** obtained from cortical neurons during visual processing tasks.  
By analyzing both single-unit and multi-unit activities, the goal is to understand how the **inferotemporal cortex (ITC)** encodes object categories such as faces, bodies, natural scenes, and artificial objects.

This repository includes:
- End-to-end **spike sorting** and **feature extraction** from extracellular recordings  
- **Single-neuron response analysis** (PSTH, Fano Factor, Mutual Information, d′)  
- **Population-level decoding** using SVM classifiers and time-resolved generalization  
- **Representational Dissimilarity Matrices (RDMs)** for representational geometry analysis  
- **Spectral and Phase-Amplitude Coupling (PAC)** characterization  
- Optional **GLM modeling** to relate neural and visual feature spaces

---

## 🧩 Data Description

The analysis uses multiple electrophysiological datasets:

- `cl_data.mat` — Simulated extracellular recording for spike sorting  
- `vasatiData.mat` — Realistic multi-neuron IT cortex recordings (92 neurons × 5000 trials × 550 timepoints)  
- `Trials.mat` — Stimulus index for each trial  
- `StmLabels.mat` — Semantic category labels (Face, Body, Natural, Artificial)

Data are sampled at 30 kHz (extracellular) and 1 kHz (spiking activity per trial).  

---

## ⚙️ Pipeline Overview

The repository is structured into modular stages. Each stage can be run independently or integrated as a full pipeline.

### 1️⃣ Signal Preprocessing and Spike Sorting

#### **Objective:**  
Extract and isolate single-neuron spike trains from extracellular voltage recordings.

#### **Steps:**

1. **Filtering**  
   - Apply a 7th-order Butterworth bandpass filter (300–3000 Hz) using `scipy.signal.filtfilt`.  
   - Removes low-frequency drift (LFP) and high-frequency noise.

2. **Spike Detection**  
   - Threshold computed using median-based noise estimation:  
     \[
     \theta = 5 \sigma_n, \quad \sigma_n = \frac{\text{median}(|x|)}{0.6745}
     \]  
   - Spikes are detected as peaks exceeding θ.

3. **Waveform Extraction**  
   - Extract ±2 ms windows around each detected spike peak.  
   - Store as rows in a waveform matrix for feature extraction.

4. **Feature Extraction (PCA / t-SNE)**  
   - Principal Component Analysis (PCA) is applied to reduce waveform dimensionality.  
   - Alternatively, **t-SNE** can be used for nonlinear feature mapping.

5. **Clustering**  
   - Use **K-Means**, **GMM**, or mixture-of-t models to cluster waveforms.  
   - Clusters correspond to putative single units.

6. **Validation**  
   - Compare detected spikes to ground-truth annotations (if available) using performance metrics (precision, recall, or correlation).

---

### 2️⃣ Single-Neuron Analysis

#### **Peri-Stimulus Time Histogram (PSTH)**
- Compute average firing rate across trials for each stimulus category.  
- Temporal bins correspond to 1 ms intervals across 0–550 ms.  
- Reveals time-locked firing dynamics and category selectivity.

#### **Fano Factor Analysis**
- Quantifies trial-to-trial variability:
  \[
  F = \frac{\mathrm{Var}(N)}{\mathbb{E}(N)}
  \]
- Mean-Matched Fano Factor (MMFF) corrects for rate differences across conditions.  
- \( F > 1 \): variable / irregular firing; \( F < 1 \): reliable responses.

#### **Mutual Information (MI)**
- Measures dependency between spike counts and stimulus categories:
  \[
  I(S;R) = \sum_{s,r} p(s,r) \log_2 \frac{p(s,r)}{p(s)p(r)}
  \]
- Computed across time to quantify information flow dynamics.  
- Permutation tests identify statistically significant periods.

#### **d′ (Discriminability Index)**
- Quantifies separability between response distributions to two stimuli:
  \[
  d′ = \frac{μ_1 - μ_2}{\sqrt{0.5(σ_1^2 + σ_2^2)}}
  \]
- High |d′| indicates stronger selectivity.

---

### 3️⃣ Population-Level Decoding

#### **Support Vector Machine (SVM) Classification**
- Spike counts (100–300 ms post-stimulus) used as features.  
- Category labels (Face, Body, Natural, Artificial) as targets.  
- Uses one-vs-rest multiclass SVM with 5-fold cross-validation.  
- Outputs:
  - Overall accuracy
  - Per-category recall and confusion matrix

#### **Time–Time Decoding**
- Train an SVM at each time point, test across all others.  
- Produces a 2D matrix showing generalization over time.  
- Diagonal structure ⇒ feedforward coding  
- Off-diagonal activation ⇒ recurrent or sustained processing

---

### 4️⃣ Representational Geometry Analysis

#### **Representational Dissimilarity Matrix (RDM)**
- Each cell = dissimilarity (1 − correlation) between population response vectors for two stimuli.  
- Constructed over time to reveal category structure evolution.  
- Compare neural RDMs to:
  - Ground truth categorical RDM  
  - Visual feature RDMs (e.g., CNN embeddings)

#### **Kendall’s Tau Correlation**
- Correlates neural RDM and ground-truth RDM across time.  
- Indicates when category structure is best represented in population activity.

#### **Generalized Linear Model (GLM)**
- Predict ground-truth RDM from neural and visual RDMs:
  \[
  Y_{gt} = \beta_0 + \beta_1 X_{neural} + \beta_2 X_{visual} + \epsilon
  \]
- Computes time-resolved R² to quantify contribution of neural vs visual structure.

---

### 5️⃣ Oscillatory and Spectral Analyses

#### **Phase-Amplitude Coupling (PAC)**
- Measures interaction between phase of low-frequency oscillations and amplitude of high-frequency activity:
  \[
  PAC(f_L, f_H) = \langle A(f_H) \cdot \cos(\theta(f_L)) \rangle
  \]
- Computed using [**Tensorpac**](https://github.com/EtienneCmb/tensorpac):
  - Method 1: Modulation Index (MI)
  - Method 2: Canolty Method

#### **Spectral Power Analysis**
- Fourier-based power spectra computed per stimulus category.  
- Identifies frequency-specific activity and category-dependent differences.

---

## 🧮 Tools and Dependencies

- **Python:** `numpy`, `scipy`, `matplotlib`, `scikit-learn`, `tensorpac`, `mne`, `pandas`  
- **MATLAB (optional):** Signal Processing Toolbox, Statistics Toolbox  
- **Visualization:** Matplotlib / Seaborn for plots, 3D scatter for feature space

---

## 📊 Example Outputs

- PSTH plots showing category-selective firing  
- Fano Factor bar charts across stimuli  
- MI and decoding accuracy over time  
- RDM time courses and τ correlations  
- PAC heatmaps and spectral density plots  

---

## 🔗 Resources

- **Project Description (Full Specification):**  
  [📄 View PDF](https://bcolabcourses.github.io/ICNSpring2025/static_files/assignments/HW2_ICNSpr2025.pdf)

- **Primary Data File:**  
  [📈 Download `cl_data.mat`](https://bcolabcourses.github.io/ICNSpring2025/static_files/assignments/cl_data.mat)

---

## 📜 License

This repository is provided for research and academic use.  
Please acknowledge this work appropriately if it informs your analyses.

---

> *“Different stimuli evoke distinct spatiotemporal patterns of activity — by decoding these signals, we gain a window into the brain’s representational language.”*
