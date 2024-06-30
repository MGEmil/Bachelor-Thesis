import logging
import time

import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie
from cflib.utils import uri_helper
from cflib.positioning.position_hl_commander import PositionHlCommander
from examples.autonomy.autonomousSequence import start_position_printing, display_coord_crazyflie
from examples.autonomy.autonomousSequence import reset_estimator

import pandas as pd
import numpy as np

# Calea către fișierul CSV
file_path = 'C:\\Users\\mereu\\Documents\\Licenta\\data_modified_obst.csv'

# Citirea datelor din fișierul CSV într-un DataFrame pandas
df = pd.read_csv(file_path)

matrix_coord = np.empty((3, df.shape[1]))

i = 0
for column in df.columns:

    try:
        matrix_coord[0][i] = float(column)
    except Exception:
        column_aux = column.split('.')
        column_aux2 = column_aux[0] + '.' + column_aux[1]
        matrix_coord[0][i] = float(column_aux2)

    for index in range(len(df)):
        if index == 0:
            matrix_coord[1][i] = df[column][index]
        elif index == 1:
            matrix_coord[2][i] = df[column][index]
    i += 1

# Verificare dacă coordonatele sunt citite corecte
# for row in matrix_coord:
#     for element in row:
#         print(element, end=' , ')
#     print()




URI = uri_helper.uri_from_env(default='radio://0/80/2M/E7E7E7E7E5')
# Only output errors from the logging framework
logging.basicConfig(level=logging.ERROR)

if __name__ == '__main__':
    # Initialize the low-level drivers
    cflib.crtp.init_drivers()

    with SyncCrazyflie(URI, cf=Crazyflie(rw_cache='./cache')) as scf:
        cf = scf.cf

        print('Resetarea estimatorilor')
        reset_estimator(scf)

        print('Parametrii încep să fie descărcați')
        start_position_printing(scf)
        cf.param.set_value('loco.mode', 2)  # 1=TWR, 2 = TDoA2, 3 = TDoA3
        while not scf.cf.param.is_updated:
            time.sleep(1.0)
        print('Parametrii au fost descărcați')

        with PositionHlCommander(cf, controller=PositionHlCommander.CONTROLLER_PID) as pc:
            for i in range(len(matrix_coord[0])):
                x = matrix_coord[0][i]
                y = matrix_coord[1][i]
                z = matrix_coord[2][i]
                pc.go_to(x, y, z)
                time.sleep(0.1)
                print('Going to {}, {}, {}'.format(x, y, z))

        matrix_crazyflie = display_coord_crazyflie(scf)

        cf.commander.send_stop_setpoint()
        # Hand control over to the high level commander to avoid timeout and locking of the Crazyflie
        cf.commander.send_notify_setpoint_stop()

    # Salvarea coordonatelor dronei într-un fișier extern
    df_coord = pd.DataFrame(matrix_crazyflie)
    file_path = "C:\\Users\\mereu\\Documents\\Licenta\\crazyflie_coord.xlsx"
    df_coord.to_excel(file_path, index=False,
                header=False)  # index=False și header=False pentru a nu include indicii sau antetele coloanelor




