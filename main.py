import numpy as np

# --- Настройки ---
formula = lambda x: (x * x - 1) / (x + 1) # <-- Введи сюда свою формулу
x_min, x_max = 0.0, 1.0                 # Диапазон скорости движения
steps = 10                              # Количество точек

# --- Расчёт ---
xs = np.linspace(x_min, x_max, steps)
ys = [round(formula(x), 4) for x in xs]

# --- Формирование профиля Hyprland ---
profile = "accel_profile = custom 1"
for x, y in zip(xs, ys):
    profile += f" {round(x, 4)} {y}"

# Убираем последний слеш
profile = profile.strip(" ")

print(profile)