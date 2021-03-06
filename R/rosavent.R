#Rosa de los vientos, con n�mero de direcciones variable
rosavent <- function(frec, fnum=4, fint=5, flab=2, ang=3*pi/16,
    col=rainbow(10,.5,.92,start=.33,end=.2), margen=c(0, 0, 4, 0),
    key=TRUE, uni="m/s", ...) {
  old.par <- par(no.readonly = TRUE)
  on.exit(par(old.par))
  if(is.matrix(frec)) frec <- as.data.frame(frec)
  #no. de direcciones y clases de velocidad:
  if(is.vector(frec)) { ndir <- length(frec); nr <- 1 }
  else { ndir <- length(frec[1,]); nr <- nrow(frec) }
  fmax <- fnum*fint  #frecuencia m�xima a se�alar con un c�rculo
  #convertimos las frecuencias a porcentajes:
  tot <- sum(frec)
  fr <- 100 * frec / tot
  key <- (nr>1) && key  #leyenda s�lo si hay varias clases
  #hacer sitio para la leyenda a la izda. del gr�fico:
  if(key) mlf <- 3 else mlf <- 1  #factor para el margen izquierdo
  par(mar=margen, new=FALSE)    #margen para la rosa de los vientos
  #componentes para cada direcci�n y preparaci�n del dibujo:
  fx <- cos(pi/2-(2*pi/ndir*0:(ndir-1)))
  fy <- sin(pi/2-(2*pi/ndir*0:(ndir-1)))
  plot(fx,fy,xlim=c(-fmax-mlf*fint,fmax+fint),ylim=c(-fmax-fint,fmax+fint),
    xaxt="n",yaxt="n",xlab="",ylab="",bty="n",asp=1,type="n", ...)
  if(nr==1) {  #una sola fila de direcciones
    cx <- fx*fr
    cy <- fy*fr
  }
  else {  #varias filas (= clases de velocidad)
    f <- apply(fr,2,sum)
    cx <- fx*f
    cy <- fy*f
    for(i in nr:2) {
      f <- f-fr[i,]
      cx <- c(cx,NA,fx*f)
      cy <- c(cy,NA,fy*f)
    }
  }
  polygon(cx,cy,col=col[nr:1])
  symbols(c(0*1:fnum),c(0*1:fnum),circles=c(fint*1:fnum),inches=FALSE,add=TRUE)
  segments(0*1:ndir,0*1:ndir,fmax*fx,fmax*fy)
  fmaxi <- fmax+fint/4
  text(0,fmaxi,"N")
  text(0,-fmaxi,"S")
  text(fmaxi,0,"E")
  text(-fmaxi,0,"W")
  if(flab==2)
    for(i in 1:fnum) text(i*fint*cos(ang),i*fint*sin(ang),paste(i*fint,"%"))
  else if(flab==1)
    text(fmax*cos(ang),fmax*sin(ang),paste(fmax,"%"))
  if(key) { #leyenda
    legend(-fmaxi-2.3*fint,fmaxi+2,fill=col,legend=attr(frec,"row.names"))
    text(-fmaxi-1.4*fint,fmaxi+.9*fint,uni)
  }
  invisible()   #reset old.par (restablecemos par�metros gr�ficos anteriores)
}
