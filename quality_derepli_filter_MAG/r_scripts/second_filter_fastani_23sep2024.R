#1.Load packages and libraries-----
library(readxl)
library(ggplot2)
library(dplyr) #mutate function
library(ggpubr)

#2.Import the table of completeness and contamination data-----
second_qfilter_data <- read_xlsx("~/Downloads/fastANI_out_secondfilter_excel_15jul2024.xlsx")
View(second_qfilter_data)

##2.1.Update the column with redundant column-----

second_qfilter_data <- second_qfilter_data %>% 
  mutate(redundant = case_when(
    ani >= 99.9 | alignment_fraction >= 95 ~ "yes",
    ani < 99.9 | alignment_fraction < 95 ~ "no"))

View(second_qfilter_data)

##2.2.Plot the completeness and contamination data-----
fastani_plot_total <- ggplot(data= second_qfilter_data, aes(x=ani, y = alignment_fraction, fill=redundant))+
  geom_point(shape=21, color = "black", alpha= 0.7) +
  scale_fill_manual(values=c("#ef8a62", "darkgray"),
                    breaks = c("yes", "no"),
                    labels = c("Redundant (1628 MAG pairs)", "No-redundant (95078 MAG pairs)"))+
  theme_minimal()+
  ylab("Alignment fraction (%)") +
  xlab("ANI (%)") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=2),
        axis.title = element_text(face = "bold", size = 12),
        axis.text = element_text(face = "bold", size = 10),
        axis.ticks.x=element_blank(),
        axis.line = element_line(linetype = "solid", size = 0.8))+
  theme(legend.position = c(0.62, 0.15),
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank(),
        legend.text = element_text(size = 7))+
  annotate("rect", xmin=89, xmax=100, ymin=48, ymax=100, alpha=0, fill="white", col = "black", linetype = "dashed")
  
#3.Extract the values with ANI >= 99.9 or alignment fraction >=95 -----
fastaani_filter_23sep2024 <- second_qfilter_data[second_qfilter_data$ani >= 99.9|
                                                   second_qfilter_data$alignment_fraction >= 95,] ## the "|" means "OR"
View(fastaani_filter_23sep2024)

#4.Delete all the rows that have the same value in the query and reference-----

fastaani_filter_2_23sep2024 <-fastaani_filter_23sep2024[!(fastaani_filter_23sep2024$query == fastaani_filter_23sep2024$reference),]
View(fastaani_filter_2_23sep2024)

##4.1.Write a csv file for the redundant genomes-----
write.csv(fastaani_filter_2_23sep2024, file = "fastaani_filter_2_23sep2024.csv")

##4.2.Plot only the redundant pairwise-----

fastani_plot_select <- ggplot(data= second_qfilter_data, aes(x=ani, y = alignment_fraction, fill=redundant))+
  geom_point(shape=21, color = "black", alpha= 0.7) +
  scale_fill_manual(values=c("#ef8a62", "darkgray"),
                    breaks = c("yes", "no"),
                    labels = c("Redundant pairwise", "No-redundant pairwise"))+
  theme_minimal()+
  ylab("Alignment fraction (%)") +
  xlab("ANI (%)") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=2),
        axis.title = element_text(face = "bold", size = 12),
        axis.text = element_text(face = "bold", size = 10),
        axis.ticks.x=element_blank(),
        axis.line = element_line(linetype = "solid", size = 0.8))+
  theme(legend.position = "none",
        legend.background = element_rect(fill = "white"),
        legend.title = element_blank())+
  scale_x_continuous(limits=c(89, 100))+
  scale_y_continuous(limits=c(48, 100))

#5.Merge the plots-----
fastani_filter_23sep2024 <- ggarrange(fastani_plot_total, fastani_plot_select,
                                      labels = c("C", "D"),
                                      ncol = 2, nrow = 1)

##5.1.Save the merged plots-----
ggsave("fastani_quality_filter_23sep2024.pdf", plot = fastani_filter_23sep2024 , width= 6.69 ,height = 4.42 , dpi = 300)


#6.Merge the two plots for the Supplementary figure manuscript-----
supplement_figure_1_23sep2024 <- ggarrange(checkm_plot_total, checkm_plot_selected,
                                         fastani_plot_total,fastani_plot_select,
                                         labels = c("A", "B", "C", "D"),
                                         ncol = 2, nrow = 2)

ggsave("supplement_figure_1_23sep2024.pdf", plot = supplement_figure_1_23sep2024 , width= 6.69 ,height = 8.85 , dpi = 300)
