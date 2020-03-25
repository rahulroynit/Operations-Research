
## ---------------------------------------------------------------------------------------------

library(ROI)
library(ROI.plugin.glpk)
library(ompr)
library(ompr.roi)
library(tidyverse)
library(magrittr)

## ---------------------------------------------------------------------------------------------

## linear programming (lp) problem
# decision variables: x1, x2
# objective function coefficients: w1 = 2, w2 = 3
# objective function: f = w1*x1 + w2*x2 = 2*x1 + 3*x2 
# constraints: 
# 3*x1 + 4*x2 <= 100
# 3*x1 + 4*x2 >= 10
# x2 - 2*x1 <= 5
# x1 >= 0; x2 >= 0
# objective: maximize f

# objective function coefficients
ofc <- list(2, 3)

# number of decision variables
n <- 2

# weights 
w <- list(c(3, 4), c(3, 4), c(-2, 1))

# lp model
model <- MIPModel()%>%
  add_variable(x[i], i = 1:n, type = "integer")%>%
  set_objective(sum_expr(ofc[[i]]*x[i], i = 1:n), "max")%>%
  add_constraint(sum_expr(w[[1]][i]*x[i], i = 1:n) <= 100)%>%
  add_constraint(sum_expr(w[[2]][i]*x[i], i = 1:n) >= 10)%>%
  add_constraint(sum_expr(w[[3]][i]*x[i], i = 1:n) <= 5)%>%
  solve_model(with_ROI(solver = "glpk"))

# optimum solution
model%>%
  get_solution(x[i])

# objective function value
model%>%
  objective_value()

## ---------------------------------------------------------------------------------------------

## knapsack problem
# number of items: n = 10
# each item has a weight = pi, i is the item index
# value of each item = ci, i is the item index
# total capacity of cargo (in weight): W = 35 units
# we have 10 decision variables: x[i], i = 1 to 10
# decision variable is a binary variable
# x[i] = 0 is item is not packed, else x[i] = 1

# number of decision variables
n <- 10

# value of items
c <- list(16, 22, 12, 8, 15, 17, 14, 16, 20, 21)

# weight of items
p <- list(5, 7, 4, 3, 6, 5, 7, 8, 4, 6)

# knapsack model (mip)
model <- MIPModel()%>%
  add_variable(x[i], i = 1:n, type = "binary")%>%
  set_objective(sum_expr(c[[i]]*x[i], i = 1:n), "max")%>%
  add_constraint(sum_expr(p[[i]]*x[i], i = 1:n) <= 35)%>%
  solve_model(with_ROI(solver = "glpk"))

# optimum solution
model%>%
  get_solution(x[i])

# objective function value
model%>%
  objective_value()

## ---------------------------------------------------------------------------------------------

