# install.packages(c("alluvial"), dependencies = TRUE)
require(alluvial)

# Titanic data
tit <- as.data.frame(Titanic)

# 4d
alluvial( tit[,1:4], freq=tit$Freq, border=NA,
          hide = tit$Freq < quantile(tit$Freq, .50),
          col=ifelse( tit$Class == "3rd" & tit$Sex == "Male", "blue", "gray") )


alluvial( tit[,1:4], freq=tit$Freq, border=NA,
          hide = tit$Freq < quantile(tit$Freq, .50),
          col=ifelse( tit$Survived == "Yes" & tit$Age == "Child", "red", "gray") )

alluvial( tit[,1:4], freq=tit$Freq, border=NA,
          hide = tit$Freq < quantile(tit$Freq, .50),
          col=ifelse( tit$Survived == "No" & tit$Sex == "Female", "violet", "gray") )

