# installed with tidyverse, but NOT loaded with library(tidyverse)
library(readxl) 
library(dplyr)
library(ggpubr)
library(tidyverse)

# import data
biomass <- "biomass2015.xls"

# find the names of the excel sheets
excel_sheets(path = biomass)

# import using path
# biomass<-map(read_excel, path="biomass2015.xls") or
# import the desired sheet - imports the first by default
biomass_L <- read_excel(path = biomass, sheet = "Site L")
biomass_M <- read_excel(path = biomass, sheet = "Site M")
biomass_A <- read_excel(path = biomass, sheet = "Site A")
biomass_H <- read_excel(path = biomass, sheet = "Site H")

# find total biomass for each plot in each site
biomass_L_p <- select(biomass_L, plot, production)
biomass_L_p$plot <- factor(biomass_L_p$plot)
site_L <- biomass_L_p %>% 
  group_by(plot) %>% 
  summarise(production= sum(production, na.rm=TRUE))
biomass_M_p <- select(biomass_M, plot, production)
biomass_M_p$plot <- factor(biomass_M_p$plot)
site_M <- biomass_M_p %>% 
  group_by(plot) %>% 
  summarise(production= sum(production, na.rm=TRUE))
biomass_A_p <- select(biomass_A, plot, production)
biomass_A_p$plot <- factor(biomass_A_p$plot)
site_A <- biomass_A_p %>% 
  group_by(plot) %>% 
  summarise(production= sum(production, na.rm=TRUE))
biomass_H_p <- select(biomass_H, plot, production)
biomass_H_p$plot <- factor(biomass_H_p$plot)
site_H <-biomass_H_p %>% 
  group_by(plot) %>% 
  summarise(production= sum(production, na.rm=TRUE))

# individual plots for each site
pL <-ggplot(site_L, aes(x=plot, y=production)) + 
  geom_bar(stat = "identity")+
  ggtitle("Site L")+
  theme_bw()
pL
pM <-ggplot(site_M, aes(x=plot, y=production)) + 
  geom_bar(stat = "identity")+
  ggtitle("Site M")+
  theme_bw()
pM
pA <-ggplot(site_A, aes(x=plot, y=production)) + 
  geom_bar(stat = "identity")+
  ggtitle("Site A")+
  theme_bw()
pA
pH <-ggplot(site_H, aes(x=plot, y=production)) + 
 geom_bar(stat = "identity")+
  ggtitle("Site H")+
  theme_bw()
pH

# combine plots and get total biomass per plot on each site
plot <- ggarrange(pL, pM, pA, pH,  ncol = 2, nrow = 2)
plot



# mean biomass per site
biomass.df <- excel_sheets(path = "biomass2015.xls") %>% 
  map_dfr(~read_excel(path = "biomass2015.xls", sheet =.x))

biomass.df <- biomass.df %>%
  select(c(site, plot, production)) %>%
  dplyr::mutate(site = factor
                (site, levels = c("L", "M", "A", "H"))) %>% 
  group_by(site, plot) %>% 
  summarise(Biomass = sum(production, na.rm = T))

pb <- ggplot(biomass.df, aes( x= site, y=Biomass, colour=site))+
  geom_boxplot()+
  theme_bw()
pb
