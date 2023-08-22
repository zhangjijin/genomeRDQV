args<-commandArgs(T)
#a<-read.table(args[1],header=F)
a<-read.table("/Users/jijin/Desktop/jm44/data/process_Final/Genome_evalutaion/jm44.1m.bed")
x<-a$V4
name<-args[2]
setwd("/Users/jijin/Desktop/jm44/data/process_Final/Genome_evalutaion/")




#library(fitdistrplus)
#iqr = quantile(x, 0.75) - quantile(x, 0.25)
#upper = quantile(x, 0.75) + 3*iqr
#lower = quantile(x, 0.25) - 3*iqr
#x1<- x[x<upper]
#x_filter<- x1[x1>lower]



pdf1<-paste(name, ".qqplot.pdf", sep = "")
pdf(pdf1)
qqnorm(x)
qqline(x, col=2, lwd=2) 
dev.off()

pdf2<-paste(name, ".hist.pdf", sep = "")
pdf(pdf2)
plot(hist(x))
dev.off()

library(ggplot2)
x_mean<-mean(x)
x_sd<-x_mean^0.5
len<-length(x)
x_norm<-as.data.frame(x)
x_norm$y <- rnorm(len, x_mean, x_sd) 


left_tail<-x_mean-3*x_sd
right_tail<-x_mean+3*x_sd

x2<-x[x<100]
x2<-as.data.frame(x2)
dense<-data.frame(density(x2$x2)[c("x","y")])

data<-data.frame(x=c(left_tail,right_tail))


pdf2<-paste(name, ".pdf", sep = "")
pdf(pdf3)
ggplot()+
  geom_histogram(data=x2,aes(x=x2,y=..density..), color="#88ada6", alpha=.25, fill="#fffbf0", binwidth = 2, center=1)+
  geom_density(data=x_norm,aes(x=y),linetype=1)+
  geom_density(data=x2,aes(x=x2),linetype = 2)+
  geom_area(data = subset(dense,x <= left_tail ), aes(x, y, fill = "Error regions"), alpha=.4)+
  geom_area(data = subset(dense,x >= right_tail), aes(x, y, fill = "Incomplete regions"), alpha=.4)+
  geom_area(data = subset(dense,x  > left_tail & x < right_tail), aes(x, y, fill = "Normal regions"), alpha=.4)+
  scale_fill_manual("Genome regions", 
                    breaks = c("Error regions", "Incomplete regions", "Normal regions"), 
                    values = c("Error regions"="#4b5cc466", "Incomplete regions"="#16a95166", "Normal regions"="#ffb61e66"))+
  labs(x = 'Reads depth',
       y = 'Density')+
  theme_classic()+
  theme(plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(size = 12, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 12, face = "italic"),
        axis.text = element_text(size=12),
        axis.title = element_text(size=14, face="bold"),
        panel.background = element_rect(colour = "black", size=1,fill=NA),legend.position = c(0.8,0.8))+
  geom_segment(aes(x = left_tail, xend = left_tail, y = 0, yend = max(dense$y)), color = "red", linetype = "dashed", size = 0.3) +
  geom_segment(aes(x = right_tail, xend = right_tail, y = 0, yend = max(dense$y)), color = "red", linetype = "dashed", size = 0.3) 

dev.off()

index<-0
index<-c(index,left_tail,right_tail)



write.table(index,file=args[3],sep='\t')

