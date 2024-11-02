#1.Load packages and libraries-----
library(readxl)
library(ggplot2)
library(dplyr) #mutate function
library(ggpubr)

#2.Import the table of completeness and contamination data-----
first_qfilter_data <- read_xlsx("~/Downloads/Table S2-Quality control MAGs.xlsx", sheet = "Table S2-A")
View(first_qfilter_data)
##2.1.Create another column about the quality of each column-----
first_qfilter_data <- first_qfilter_data %>% 
                      mutate(quality = case_when(
                        completeness > 90 & contamination < 5 ~ "high_q",
                        completeness >= 50 & contamination < 10 ~ "medium_q",
                        completeness < 50 & contamination < 10 ~ "low_q",
                        TRUE ~ "no_classfied"))
View(first_qfilter_data)
##2.2.Get the number of high quality, medium quality and low quality genomes-----
#quality->n
#high_q->817
#low_q->6
#medium_q->116
#no_classfied->13

##2.3.Save the update table in excel format-----
write.csv(first_qfilter_data, file = "first_qfilter_data.csv")
#3.Create the plot-----
##3.1.Create a plot with all the point-----
checkm_plot_total <- ggplot(data= first_qfilter_data, aes(x=completeness, y = contamination, fill = quality))+
              geom_point(shape=21, color = "black", alpha= 0.7) +
              scale_fill_manual(values=c("#ef8a62", "#67a9cf", "darkgray", "white"),
                                breaks = c("high_q", "medium_q", "low_q", "no_classfied"),
                                labels = c("High quality (817 genomes)", "Medium quality (116 genomes)", "Low quality (6 genomes)", "no classified (13 genomes)"))+
  theme_minimal()+
  ylab("Contamination (%)") +
  xlab("Completeness (%)") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=2),
        axis.title = element_text(face = "bold", size = 12),
        axis.text = element_text(face = "bold", size = 10),
        axis.ticks.x=element_blank(),
        axis.line = element_line(linetype = "solid", size = 0.8))+
  theme(legend.position = c(0.35, 0.80),
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(),
        legend.text = element_text(size = 7))+
  annotate("rect", xmin=50, xmax=100, ymin=0, ymax=5, alpha=0, fill="white", col = "black", linetype = "dashed")#create a rectangle in th plot

###3.1.1.Save the plot-----
ggsave("checkm_plot_total_14jul2024.pdf", plot = checkm_plot_total, width =150, height =100 , units  = "mm", limitsize = FALSE)
ggsave("checkm_plot_total_14jul2024.tiff", plot = checkm_plot_total, width =200, height =200 ,  units = "mm", limitsize = FALSE)


##3.2.Save the plot as a rds object-----
saveRDS(checkm_plot_total, file = "checkm_plot_total_25sep2024.RDS")

##3.2.Create the plot with all the points higher than 50 and 10-----
checkm_plot_selected <- ggplot(data= first_qfilter_data, aes(x=completeness, y = contamination, fill = quality))+
  geom_point(shape=21, color = "black", alpha=0.7) +
  scale_fill_manual(values=c("#ef8a62", "#67a9cf", "darkgray", "white"),
                    breaks = c("high_q", "medium_q", "low_q", "no_classfied"),
                    labels = c("High quality (817 genomes)", "Medium quality (116 genomes)", "Low quality (6 genomes)", "no classified (13 genomes)"))+
  theme_minimal()+
  ylab("Contamination (%)") +
  xlab("Completeness (%)") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=2),
        axis.title = element_text(face = "bold", size = 12),
        axis.text = element_text(face = "bold", size = 10),
        axis.ticks.x=element_blank(),
        axis.line = element_line(linetype = "solid", size = 0.8))+
  theme(legend.position = "none",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank())+
  scale_x_continuous(limits=c(50, 100))+
  scale_y_continuous(limits=c(0, 5))
###3.2.1.Save the plot-----
ggsave("checkm_plot_selected _14jul2024.pdf", plot = checkm_plot_selected , width =150, height =100 , units  = "mm", limitsize = FALSE)

##3.3.Save the plot as a rds object-----
saveRDS(checkm_plot_selected, file = "checkm_plot_selected_25sep2024.RDS")

#4.Merge the plots-----
quality_filter_14jul2024 <- ggarrange(checkm_plot_total, checkm_plot_selected,
                    labels = c("A", "B"),
                    ncol = 2, nrow = 1)

##4.1.Save the merged plots-----
ggsave("checkm_quality_filter_14jul2024.pdf", plot = quality_filter_14jul2024 , width =200, height =150 , units  = "mm", limitsize = FALSE)


#5.Get the accesion numbers with high quality-----
##5.1.Filter the table to get only the high_q related data-----
first_qfilter_highq_data <- first_qfilter_data %>% filter(quality == "high_q")
View(first_qfilter_highq_data)

##5.2.Create an object that contains the accession number of the high quality data----
checkm_firstfilter_accesionnumber <- first_qfilter_highq_data$accesion_number

##5.2.Create a text file with the accession number of the high quality data-----
write(checkm_firstfilter_accesionnumber, file = "checkm_firstfilter_accesionnumber.txt")