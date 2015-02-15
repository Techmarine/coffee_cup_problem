
initial_temperature = 85;
cooler_temperature = 25;
milk_temperature = 4;
optimal_temperature = 50;
k = 1/60;

cup_volume = 350e-3; %L
num_of_teaspoons = 2;
teaspoon = 4.92e-3; %teaspoon volume
water_density = 999.97; %kg/m^3
p = 0.8; %amount of coffee in cup without milk (percentage)
water_mass = water_density*(cup_volume - num_of_teaspoons*teaspoon)*p;
coffee_mass_per_teaspoon = 3.3e-3; %kg
coffee_mass = coffee_mass_per_teaspoon*num_of_teaspoons;
brewed_coffee_mass = coffee_mass + water_mass;
milk_mass = water_density*(cup_volume - num_of_teaspoons*teaspoon)*(1 - p);

time = linspace(0,5*60,1000);
milk_time = 20;
[~,time_to_add_milk] = min(abs(time - milk_time)); %time index of milk time

temperature = initial_temperature;
f = @(temperature,k,cooler_temperature) -k*(temperature - cooler_temperature);
for i = 2:length(time)
    if i == time_to_add_milk
        %assuming that brewed coffee and milk have the same heat capacity as water
        mixture_temperature = (brewed_coffee_mass*temperature(i-1) + milk_mass*milk_temperature)/...
            (brewed_coffee_mass + milk_mass);
        temperature(i) = mixture_temperature;
    else
        step = (time(i) - time(i-1));
        temperature(i) = temperature(i-1) + step*f(temperature(i-1),k,cooler_temperature);
    end
end
[~,index] = min(abs(temperature - optimal_temperature));

figure;
hold on;
plot(time,temperature);
plot([0,max(time)],[temperature(index),temperature(index)],'--red');
hold off;
grid on;
xlabel('Time');
ylabel('Temperature');