## ---- echo = FALSE, message = FALSE, warning = FALSE--------------------------
library(Andromeda)

## ----eval=TRUE----------------------------------------------------------------
library(Andromeda)
andr <- andromeda()

## ----eval=TRUE----------------------------------------------------------------
andr$cars <- cars
andr

## ----eval=FALSE---------------------------------------------------------------
#  andr <- andromeda(cars = cars)

## ----eval=TRUE----------------------------------------------------------------
appendToTable(andr$cars, cars)

## ----eval=TRUE----------------------------------------------------------------
andr2 <- andromeda()
andr2$cars <- andr$cars

## ----eval=TRUE----------------------------------------------------------------
andr3 <- copyAndromeda(andr)

## ----eval=TRUE----------------------------------------------------------------
close(andr)
close(andr2)
close(andr3)

## ----eval=TRUE----------------------------------------------------------------
isValidAndromeda(andr)

## ----eval=FALSE---------------------------------------------------------------
#  options(andromedaTempFolder = "c:/andromedaTemp")

## ----eval=TRUE----------------------------------------------------------------
andr <- andromeda(cars = cars)
andr$cars %>%
  filter(speed > 10) %>%
  count() %>%
  collect()

## ----eval=TRUE----------------------------------------------------------------
andr$fastCars <- andr$cars %>%
  filter(speed > 10)

## ----eval=TRUE----------------------------------------------------------------
names(andr)
colnames(andr$cars)
nrow(andr$cars)
ncol(andr$cars %>% select(speed))

## ----eval=TRUE----------------------------------------------------------------
RSQLite::dbGetQuery(andr, "SELECT * FROM cars LIMIT 5;")

## ----eval=TRUE----------------------------------------------------------------
doSomething <- function(batch, multiplier) {
  return(nrow(batch) * multiplier)
}
result <- batchApply(andr$cars, doSomething, multiplier = 2, batchSize = 10)
result <- unlist(result)
result

## ----eval=TRUE----------------------------------------------------------------
doSomething <- function(batch, multiplier) {
  return(nrow(batch) * multiplier)
}
result <- groupApply(andr$cars %>% filter(speed > 10), 
                     doSomething, 
                     groupVariable = "speed", 
                     multiplier = 2)
result <- unlist(result)
result

## ----eval=TRUE----------------------------------------------------------------
doSomething <- function(batch) {
    batch$speedSquared <- batch$speed^2
    if (is.null(andr$cars2)) {
      andr$cars2 <- batch
    } else {
      appendToTable(andr$cars2, batch)
    }
  }
  batchApply(andr$cars, doSomething, safe = TRUE)

## ----eval=TRUE----------------------------------------------------------------
andr$cars2 <-
  andr$cars %>%
  mutate(speedSquared = speed^2)

## ----eval=FALSE---------------------------------------------------------------
#  saveAndromeda(andr, "c:/temp/andromeda.zip")

## ----eval=TRUE, echo=FALSE----------------------------------------------------
writeLines("Disconnected Andromeda. This data object can no longer be used")

## ----eval=FALSE---------------------------------------------------------------
#  andr <- loadAndromeda("c:/temp/andromeda.zip")

