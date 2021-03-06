#' Plot nGenes, UMIs and perecent mito
#'
#' This function takes an object of class scSeqR and creats plot.
#' @param x An object of class scSeqR.
#' @param cell.size A numeric value for the size of the cells, defults = 1.
#' @param plot.type Choose between "tsne" and "pca", defult = "tsne".
#' @param cell.color Choose cell color if col.by = "monochrome", defult = "black".
#' @param back.col Choose background color, defult = "black".
#' @param col.by Choose between "clusters", "conditions" or "monochrome", defult = "clusters".
#' @param cell.transparency A numeric value between 0 to 1, defult = 0.5.
#' @param clust.dim A numeric value for plot dimentions. Choose either 2 or 3, defult = 2.
#' @param interactive If TRUE an html intractive file will be made, defult = TRUE.
#' @param out.name Output name for html file if interactive = TRUE defult = "plot".
#' @param angle A number to rotate the non-interactive 3D plot.
#' @param density If TRUE the density plots for PCA/tSNE second dimention will be created, defult = FALSE.
#' @return An object of class scSeqR.
#' @examples
#' \dontrun{
#' tsne.plot(my.obj)
#' }
#' @import ggplot2
#' @import RColorBrewer
#' @import scatterplot3d
#' @export
cluster.plot <- function (x = NULL,
                          cell.size = 1,
                          plot.type = "tsne",
                          cell.color = "black",
                          back.col = "white",
                          col.by = "clusters",
                          cond.shape = F,
                          cell.transparency = 0.5,
                          clust.dim = 2,
                          angle = 20,
                          density = F,
                          interactive = TRUE,
                          out.name = "plot") {
  if ("scSeqR" != class(x)[1]) {
    stop("x should be an object of class scSeqR")
  }
  if (clust.dim != 2 && clust.dim != 3) {
    stop("clust.dim should be either 2 or 3")
  }
  ###########
  # 2 dimentions
  if (clust.dim == 2) {
    if (plot.type == "tsne") {
      MyTitle = "tSNE Plot"
      DATA <- x@tsne.data
    }
    if (plot.type == "pca") {
      MyTitle = "PCA Plot"
      DATA <- x@pca.data
    }
    if (plot.type == "dst") {
      MyTitle = "DST Plot"
      DATA <- x@diff.st.data
    }
  }
  # 3 dimentions
  if (clust.dim == 3) {
    if (plot.type == "tsne") {
      MyTitle = "3D tSNE Plot"
      DATA <- x@tsne.data.3d
    }
    if (plot.type == "pca") {
      MyTitle = "3D PCA Plot"
      DATA <- x@pca.data
    }
    if (plot.type == "dst") {
      MyTitle = "3D DST Plot"
      DATA <- x@diff.st.data
    }
  }
  # conditions
  if (col.by == "conditions") {
    col.legend <- data.frame(do.call('rbind', strsplit(as.character(rownames(DATA)),'_',fixed=TRUE)))[1]
    col.legend <- factor(as.matrix(col.legend))
    }
  # clusters
  # always use hierarchical (k means changes everytime you run)
  if (col.by == "clusters") {
    if (is.null(x@cluster.data$Best.partition)) {
      stop("Clusters are not assigend yet, please run assign.clust fisrt.")
    } else {
      col.legend <- factor(x@best.clust$clusters)
    }
  }
  # monochrome
  if (col.by == "monochrome") {
    if (clust.dim == 2) {
    myPLOT <- ggplot(DATA, aes(DATA[,1], y = DATA[,2],
                               text = row.names(DATA))) +
      geom_point(size = cell.size, col = cell.color, alpha = cell.transparency) +
      guides(colour = guide_legend(override.aes = list(size=5))) +
      xlab("Dim1") +
      ylab("Dim2") +
      ggtitle(MyTitle) +
      scale_color_discrete(name="") +
      theme(panel.background = element_rect(fill = back.col, colour = "black"),
            panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            legend.key = element_rect(fill = back.col)) + theme_bw()
    }
    if (clust.dim == 3) {
      myPLOT <- plot_ly(DATA, x = DATA[,1], y = DATA[,2], z = DATA[,3], text = row.names(DATA),
              opacity = cell.transparency, marker = list(size = cell.size + 2, color = cell.color)) %>%
        layout(DATA, x = DATA[,1], y = DATA[,2], z = DATA[,3]) %>%
        layout(plot_bgcolor = back.col) %>%
        layout(paper_bgcolor = back.col) %>%
        layout(title = MyTitle,
             scene = list(xaxis = list(title = "Dim1"),
                          yaxis = list(title = "Dim2"),
                          zaxis = list(title = "Dim3")))
      }
    }
# plot 2d
  if (clust.dim == 2) {
    if (cond.shape == F) {
      if (interactive == F) {
        myPLOT <- ggplot(DATA, aes(DATA[,1], y = DATA[,2],
                                   text = row.names(DATA), color = col.legend)) +
          geom_point(size = cell.size, alpha = cell.transparency) +
          guides(colour = guide_legend(override.aes = list(size=5))) +
          xlab("Dim1") +
          ylab("Dim2") +
          ggtitle(MyTitle) +
          scale_color_discrete(name="") +
          theme(panel.background = element_rect(fill = back.col, colour = "black"),
                panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                legend.key = element_rect(fill = back.col))
      }
      if (interactive == T) {
        myPLOT <- ggplot(DATA, aes(DATA[,1], y = DATA[,2],
                                   text = row.names(DATA), color = col.legend)) +
          geom_point(size = cell.size, alpha = cell.transparency) +
          guides(colour = guide_legend(override.aes = list(size=5))) +
          xlab("Dim1") +
          ylab("Dim2") +
          ggtitle(MyTitle) +
          scale_color_discrete(name="") +
          theme_bw()
      }
    }
      if (cond.shape == T) {
        conds.sh <- data.frame(do.call('rbind', strsplit(as.character(rownames(DATA)),'_',fixed=TRUE)))[1]
        cond.shape <- factor(as.matrix(conds.sh))
        if (interactive == F) {
          myPLOT <- ggplot(DATA, aes(DATA[,1], y = DATA[,2],
                                     text = row.names(DATA), color = col.legend, shape = cond.shape)) +
            geom_point(size = cell.size, alpha = cell.transparency) +
            guides(colour = guide_legend(override.aes = list(size=5))) +
            xlab("Dim1") +
            ylab("Dim2") +
            ggtitle(MyTitle) +
            scale_color_discrete(name="") +
            theme(panel.background = element_rect(fill = back.col, colour = "black"),
                  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                  legend.key = element_rect(fill = back.col))
        }
        if (interactive == T) {
          myPLOT <- ggplot(DATA, aes(DATA[,1], y = DATA[,2],
                                     text = row.names(DATA), color = col.legend, shape = cond.shape)) +
            geom_point(size = cell.size, alpha = cell.transparency) +
            guides(colour = guide_legend(override.aes = list(size=5))) +
            xlab("Dim1") +
            ylab("Dim2") +
            ggtitle(MyTitle) +
            scale_color_discrete(name="") +
            theme_bw()
      }
    }
  }
# plot 3d
  if (clust.dim == 3) {
    if (interactive == T) {
#      DATAann <- as.data.frame(x@cluster.data$Best.partition)
      DATAann <- as.data.frame(x@best.clust)
      A = (row.names(DATAann))
      colnames(DATAann) <- ("clusters")
      B = as.character(as.matrix(DATAann[1]))
      ANNOT <- paste(A,"clust",B,sep="_")
    myPLOT <- plot_ly(DATA, x = DATA[,1], y = DATA[,2], z = DATA[,3], text = ANNOT,
                      color = col.legend, opacity = cell.transparency, marker = list(size = cell.size + 2)) %>%
      layout(DATA, x = DATA[,1], y = DATA[,2], z = DATA[,3]) %>%
      layout(plot_bgcolor = back.col) %>%
      layout(paper_bgcolor = back.col) %>%
      layout(title = MyTitle,
           scene = list(xaxis = list(title = "Dim1"),
                        yaxis = list(title = "Dim2"),
                        zaxis = list(title = "Dim3")))
  } else {
    # colors
#    col.legend <- factor(x@best.clust$clusters)
    qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
    colors = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
    colors <- c(colors[1:3],colors[5:30])
    if (col.by == "clusters") {
      cols <- colors[as.numeric(x@best.clust$clusters)]
      col.legend <- as.factor(x@best.clust$clusters)

    }
    if (col.by == "conditions") {
      col.legend <- data.frame(do.call('rbind', strsplit(as.character(rownames(DATA)),'_',fixed=TRUE)))[1]
      col.legend <- factor(as.matrix(col.legend))
      cols <- colors[col.legend]
    }
    #
    scatterplot3d (x = DATA[,2], y = DATA[,3], z = DATA[,1],
                color = cols,
                pch = 19,
                xlab = "Dim2", ylab = "Dim3",zlab = "Dim1",
                main = MyTitle,
                grid = T,
                box = T,
                scale.y = 1,
                angle = angle,
                mar = c(3,3,3,6)+0.1,
                cex.axis = 0.6,
                cex.symbols = cell.size,
                highlight.3d = FALSE)
    # legend
    legend("topright", legend = levels(col.legend),
           col =  colors,
           pch = 19,
           inset = -0.1,
           xpd = T,
           horiz = F)
#    scatter3D(x = DATA[,2], y = DATA[,3], z = DATA[,1],
#              colvar = NULL,
#              col = col.legend,
#              pch = 19,
#              cex = 1,
#              colkey = T,
#              col.panel ="steelblue",
#              col.grid = "darkblue",
#              ticktype = "detailed",
#              bty ="g",
#              d = 2,
#             phi = 10,
#              theta = 15)
    myPLOT = "plot made"
  }
}
  # density plot
#  col.legend <- factor(x@best.clust$clusters)
  if (density == T) {
    myPLOT <- ggplot(DATA, aes(DATA[,2], fill = col.legend)) +
      geom_density(alpha=cell.transparency) +
      xlab("Dim2") +
      scale_color_discrete(name="") + theme_bw()
  }
# return
  if (interactive == T) {
    OUT.PUT <- paste(out.name, ".html", sep="")
    htmlwidgets::saveWidget(ggplotly(myPLOT), OUT.PUT)
  } else {
    return(myPLOT)
    }
}

