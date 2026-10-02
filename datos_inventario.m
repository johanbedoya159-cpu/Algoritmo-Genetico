function datos = datos_inventario()


datos.D     = [12000  80000 150000 50000 100000];  
datos.m     = [   20    220    900   120    180];  
datos.mu    = [  300   4000   7000  2000   3500];  
datos.sigma = [  100   1200   2500   700   1100];  

datos.S_max = [  200   1200   2500   800   1500];  
datos.K_max = [  500   2000   5000  1500   3000];  

datos.I = 8000;   


datos.Q_max = 2 * datos.I * ones(1, 5);

datos.n_items = 5;
end
