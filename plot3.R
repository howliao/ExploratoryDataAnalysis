## check if "data" directory exist under the working directory, create one if not
if(!file.exists("./data")){dir.create("./data")} 

## download data to "data" folder and named it as "household_power_consumption.zip"
dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"  
download.file(dataUrl, destfile="./data/household_power_consumption.zip", method="curl")  

## extract the downloaded .zip file and put them under the "data" directory
unzip("./data/household_power_consumption.zip", exdir="./data")  

## list extracted files
pathEx <- file.path("./data")
list.files(pathEx, recursive=TRUE)

## load the data to R
data_full <- read.csv("./data/household_power_consumption.txt", header=TRUE, sep=';', na.strings="?",
                      stringsAsFactors=FALSE)

## subset data_full to extract data on date 2007-02-01 and 2007-02-02
data <- data_full[data_full$Date == "1/2/2007" | data_full$Date == "2/2/2007",]

## remove data_full to free memory
rm(data_full)

## add a "Time" variable to the data table
data$Date <- sub("1/2/2007", "01/02/2007", data$Date)
data$Date <- sub("2/2/2007", "02/02/2007", data$Date)
time <- paste(as.Date(data$Date, format = "%d/%m/%Y"), data$Time)
data$Time <- as.POSIXct(time)

## make Plot 3: line plot of sub metering over time
with(data, {
        plot(Sub_metering_1 ~ Time, type = "l",
             ylab = "Energy sub metering", xlab = "")
        lines(Sub_metering_2 ~ Time,col = "Red")
        lines(Sub_metering_3 ~ Time,col = "Blue")
})
legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 2,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Saving to PNG file
dev.copy(png, file = "plot3.png", height = 480, width = 480)
dev.off()