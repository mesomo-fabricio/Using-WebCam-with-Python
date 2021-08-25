- 👋 Hi, I’m @mesomo-fabricio
- 👀 I’m interested in ...
- 🌱 I’m currently learning ...
- 💞️ I’m looking to collaborate on ...
- 📫 How to reach me ...

<!---
mesomo-fabricio/mesomo-fabricio is a ✨ special ✨ repository because its `README.md` (this file) appears on your GitHub profile.
You can click the Preview link to take a look at your changes.
--->

import cv2 as cv
import numpy as np
import time

webcam = cv.VideoCapture(0)

while True:
    _, frame = webcam.read()  # devolve dois dados (ignoramos o 1º argumento de)
    # etapas de processamento
    #frame = cv.cvtColor(frame,cv.COLOR_BGRA2RGB)
    
    # etapas de processamento
    cv.imshow("webcam", frame)
    tecla = cv.waitKey(60)  # leia o teclado a cada 60 milisegundos
    if tecla == 27:  # 27 é o esc
        break
    elif tecla == ord("s"):
        timestr = time.strftime("%Y%m%d-%H%M%S")
        cv.imwrite("Frame"+timestr+".png", frame)

cv.destroyAllWindows()
