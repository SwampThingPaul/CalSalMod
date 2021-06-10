library(hexSticker)

#Original version
imgurl="C:/Julian_LaCie/_GitHub/CalSalMod/Hex/sal_grad.png"
# sticker(imgurl, package="CalSalMod", 
#         p_size=17, s_x = 1, s_y = 1.16, s_width = 0.95, s_height = 0.95,p_y=1.1,
#         h_fill = "#ffffff", p_color  = "#000000", h_color = "#000000",
#         p_family="serif",filename="Hex/CalSalMod.png")


## Hacked version

library(ggplot2)
library(ggimage)
library(hexSticker)
library(magick)

fill="grey80";#"#000000"
color="black";#"#ffffff"
subplot=imgurl
size=1
s_x=1.4
s_y=1.0
s_width=1.2
t_x=1
t_y=0.5
text.val="CalSalMod"
t_color="black"
font.val="serif"
t_size=5

hexd <- data.frame(x = 1 + c(rep(-sqrt(3)/2, 2), 0, rep(sqrt(3)/2,2), 0), y = 1 + c(0.5, -0.5, -1, -0.5, 0.5, 1))
hexd <- rbind(hexd, hexd[1, ])
d <- data.frame(x = s_x, y = s_y, image = subplot)
d.txt <- data.frame(x = t_x, y = t_y, label = text.val)

#windows()
hex.stick=
  ggplot()+
  geom_polygon(aes_(x = ~x, y = ~y), data = hexd, size = size,fill = fill, color = color)+
  geom_image(aes_(x = ~x, y = ~y, image = ~image),d, size = s_width)+ 
  theme_sticker(size)+
  geom_text(aes_(x = 1, y = 1.6, label = "CalSalMod"),size = t_size, color = t_color, family = font.val )+
  geom_text(aes_(x = 1.5, y = 0.35, label = "Salinity Model"),angle=30,family=font.val,fontface="plain",color="black",size=2)+
  #geom_text(aes_(x = 0.6, y = 1.71, label = "Bulseco-McKim, Carey, Sethna, Thomas, Julian"),angle=30,family=font.val,fontface="italic",color="black",size=3)+
  geom_text(aes_(x = 0.5, y = 0.35, label = "Caloosahatchee Estuary"),angle=-30,family=font.val,fontface="plain",color="black",size=2)
hex.stick
ggsave(hex.stick, width = 43.9, height = 50.8, 
       filename = "C:/Julian_LaCie/_GitHub/CalSalMod/Hex/CalSalMod_hex.png", 
      bg = "transparent", units = "mm", dpi=300)

## turn showtext off if no longer needed
showtext_auto(FALSE) 
