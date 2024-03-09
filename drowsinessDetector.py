import cv2
import numpy as np
import dlib
from imutils import face_utils
import pygame
import asyncio
import socket

SERVER_PORT = 8080 
SERVER_IP = '192.168.43.39'
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((SERVER_IP, SERVER_PORT))
server_socket.listen()
message1 = "Driver is sleepy"
message2 = "Driver is very drowsy"
cap = cv2.VideoCapture(0)
hog_face_detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")
sleep = 0
yawn_counter = 0
alarm_counter=0
escalate_counter=0
status=""
yawns=0
color=(0,0,0)


def play_audio():
    pygame.mixer.init()
    pygame.mixer.music.load('Alert.mp3')
    pygame.mixer.music.play()

async def delayed_execution(seconds):
    await asyncio.sleep(seconds)

def compute(ptA,ptB):
	dist = np.linalg.norm(ptA - ptB)
	return dist
def lip_distance(shape):
    top_lip = shape[50:53]
    top_lip = np.concatenate((top_lip, shape[61:64]))

    low_lip = shape[56:59]
    low_lip = np.concatenate((low_lip, shape[65:68]))

    top_mean = np.mean(top_lip, axis=0)
    low_mean = np.mean(low_lip, axis=0)

    distance = abs(top_mean[1] - low_mean[1])
    return distance
def blinked(a,b,c,d,e,f):
	up = compute(b,d) + compute(c,e)
	down = compute(a,f)
	ratio = up/(2.0*down)
	if(ratio<=0.19):
		return 1
        
def alarms(client_socket):
       global alarm_counter
       global yawns
       global yawn_counter
       global sleep
       if (alarm_counter>=5 and yawns == 2):
              
              print(message1)
              client_socket.sendall(message1.encode())
              play_audio()

              
       elif(alarm_counter>9 and yawns >=3):
         print(message2)
         client_socket.sendall(message2.encode())
         alarm_counter=0
         #client_socket.close()
              
       

def main():
    global color
    global sleep
    global yawns
    global yawn_counter
    global alarm_counter
    global status
    print(f"DCDS is running on {SERVER_IP}:{SERVER_PORT}")
    client_socket, client_address = server_socket.accept()
    print(f"Connection established with {client_address}")
    while True:
        
        _, frame = cap.read()
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        face_frame = frame.copy()
        faces = hog_face_detector(gray)
        for face in faces:
            x1 = face.left()
            y1 = face.top()
            x2 = face.right()
            y2 = face.bottom()
            cv2.rectangle(face_frame, (x1, y1), (x2, y2), (0, 255, 0), 2)

            landmarks = predictor(gray, face)
            landmarks = face_utils.shape_to_np(landmarks)

            
            left_blink = blinked(landmarks[36],landmarks[37], 
            landmarks[38], landmarks[41], landmarks[40], landmarks[39])
            right_blink = blinked(landmarks[42],landmarks[43], 
            landmarks[44], landmarks[47], landmarks[46], landmarks[45])

            
            if(left_blink==1 or right_blink==1):
                sleep+=1
                print("Ear per frame {}".format(sleep))
                if(sleep>20):
                    status="Drowsy!!!"
                    alarm_counter+=1
                    print("Ears per 20 frame {}".format(alarm_counter))
                    color = (0, 255, 0)
                    alarms(client_socket)
                    sleep=0
            else:
                status=""
             #(yawn detection)
            distance = lip_distance(landmarks)
            if distance > 25:
                #adjust threshold as per lighting conditions 
                yawn_counter += 1
                print("Yawns per frame {}".format(yawn_counter))
                if yawn_counter > 25:
                    yawns+=1
                    print("Yawns after 25 frames {}".format(yawns))
                    alarms(client_socket)
                    yawn_counter = 0




            cv2.putText(face_frame, status, (100, 100), cv2.FONT_HERSHEY_SIMPLEX, 1.2, color, 3)
            cv2.putText(face_frame, "EAR: {:.2f}".format(sleep), (300, 30),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
            cv2.putText(face_frame, "YAWN: {:.2f}".format(distance), (300, 60),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
            for n in range(0, 68):
                (x, y) = landmarks[n]
                cv2.circle(face_frame, (x, y), 1, (0, 255, 0), -1)

        cv2.imshow("Frame", face_frame)
        key = cv2.waitKey(1)
        if key == ('q'):
            break

if __name__ == "__main__":
    main()