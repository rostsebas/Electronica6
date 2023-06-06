import cv2
import serial
import time
import numpy as np
port = '/dev/cu.usbmodem0E222451'
baudrate = 115200
tiempo_espera = 0.0025
def enviar(dato):
    i = chr(dato)#convierte los int en ascii
    print(dato)
    x_1 = bytes(i, 'latin_1')#
    tivaPort = serial.Serial(port, baudrate, bytesize=8,
                             parity='N',
                             stopbits=1)
    tivaPort.write(x_1)
    tivaPort.close()
    time.sleep(tiempo_espera)

def Cambio_colores(valor, OldMin, OldMax, NewMin, NewMax):
    OldRange = (OldMax - OldMin)
    NewRange = (NewMax - NewMin)
    NewValue = (((valor - OldMin) * NewRange) / OldRange) + NewMin
    return int(round(NewValue))


def convert_to_uart(matriz_datos_imagen):
    pixeles=[]
    for i in matriz_datos_imagen:
        for j in i:
            binary_repr_v = np.vectorize(np.binary_repr)
            bin_B = binary_repr_v(j[0], 2)  # Datos binario de Blue
            bin_G = binary_repr_v(j[1], 3)  # Datos binarios de Green
            bin_R = binary_repr_v(j[2], 3)  # Datos binarios de Red
            data = str((str(bin_B) + str(bin_G) + str(bin_R)))
            Num_data = 0
            j = 7
            for i in data:
                Num_data = int(i) * pow(2, j) + Num_data
                j -= 1
            pixeles.append(int(Num_data))

    print('-----------------------------------------------------------------------')
    print('pixel en enteros')
    print(len(pixeles))
    print('-----------------------------------------------------------------------')
    print('Enviadno Datos porfavor Espere')
    print(pixeles)
    #for m in pixeles:
     #   enviar(int(m))
    print('-----------------------------------------------------------------------')
    print('Datos Enviados, si desea volver a enviar escriba: imagen(nombre,filas,columnas) ')


def imagen (nombre = 'mario.jpg',filas=64,columnas=64):
    img = cv2.imread(nombre)

    print('-----------------------------------------------------------------------')
    print('Dantos de la imagen de entrada')
    print(str('Filas')+'| Columnas '+'| Canales')
    print(img.shape) # retorna una tupla con el numero de , filas, columnas y canales
    print('tamaño de la imagen')
    print(img.size) # retorna la cantidad de pixeles de la imagen
    print('-----------------------------------------------------------------------')
    #cv2.imshow('image', img)
    #cv2.waitKey(5000)
    #cv2.destroyAllWindows()

    img = cv2.resize(img, (filas, columnas))
    print(img)
    B, G, R = cv2.split(img)

    for i in range(len(B)):
        for j in range(len(B[0])):
            B[i][j] = Cambio_colores(B[i][j],0,255,0,3)

    for i in range(len(G)):
        for j in range(len(G[0])):
            G[i][j] = Cambio_colores(G[i][j],0,255,0,7)

    for i in range(len(R)):
        for j in range(len(R[0])):
            R[i][j] = Cambio_colores(R[i][j],0,255,0,7)

    img= cv2.merge((B, G, R))
    print(img)
    #cv2.imwrite('rojo_64.jpg', img)
    print('-----------------------------------------------------------------------')
    print('Dantos de Nueva imagen')
    print(str('Filas')+'| Columnas '+'| Canales')
    print(img.shape) # retorna una tupla con el numero de , filas, columnas y canales
    print('tamaño de la imagen')
    print(img.size) # retorna la cantidad de pixeles de la imagen
    print('-----------------------------------------------------------------------')

    convert_to_uart(img)
#imagen()
imagen('rojo.jpg',64,64)


