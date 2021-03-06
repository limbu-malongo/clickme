context("Points data")

test_that("order data by color_groups", {

    params <- list(x = c(1, 2, 3, 4, 5),
                   y = NULL,
                   color_groups = c(.1, .2, .3, .4, .5),
                   palette = c("#000", "#fff"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$x,
                 c(5, 4, 3, 2, 1),
                 info = "quantitative color_groups, unnamed palette") # .5 .4 .3 .2 .1 (smallest on top)

    params <- list(x = c(1, 2, 3, 4, 5),
                   y = NULL,
                   color_groups = c("c", "a", "b", "c", "b"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$x,
                 c(4, 1, 5, 3, 2),
                 info = "categorical color_groups, no palette") # c c b b a ("a" on top)

    params <- list(x = c(1, 2, 3, 4, 5),
                   y = NULL,
                   color_groups = c("c", "a", "b", "c", "b"),
                   palette = c("blue", "red", "green"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$x,
                 c(4, 1, 5, 3, 2),
                 info = "categorical color_groups, unnamed palette") # c c b b a ("a" on top)

    params <- list(x = c(1, 2, 3, 4, 5),
                   y = NULL,
                   color_groups = c("c", "a", "b", "c", "b"),
                   palette = c(a = "blue", c = "green", b = "red"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$x,
                 c(5, 3, 4, 1 ,2),
                 info = "categorical color_groups, named palette") # b b c c a ("a" on top)

    params <- list(x = c("a", "b"),
                   y = data.frame(a = c(1,2,3), b = c(4,5,6)),
                   color_groups = c("A", "B", "C"))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$color_group,
                 c("C", "C", "B", "B", "A", "A"),
                 info = "categorical color_groups, multiple of number of points")
})

test_that("extra fields get added", {
    # extra can be a data frame, a list or a matrix
    params <- list(x = c("a", "b", "c"),
                   y = 1:3,
                   extra = data.frame(extra1 = c(10,20,30),
                                      extra2 = c(100,200,300)))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equivalent(points$data, data.frame(x = c("a", "b", "c"),
                                              y = 1:3,
                                              extra1 = c(10,20,30),
                                              extra2 = c(100, 200, 300),
                                              radius = 5,
                                              point_name = as.character(1:3)
                                              ))

    params <- list(x = c("a", "b", "c", "d"),
                   y = c(1:3, NA),
                   extra = data.frame(extra1 = c(10,20,30,40),
                                      extra2 = c(100,200,300,400)))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equivalent(points$data,
                      data.frame(x = c("a", "b", "c"),
                                 y = 1:3,
                                 extra1 = c(10,20,30),
                                 extra2 = c(100, 200, 300),
                                 radius = 5,
                                 point_name = as.character(1:3)
                                 ))
})

test_that("limits reduce the size of the data", {
    params <- list(x = 1:10,
                   y = 1:10,
                   x_lim = c(2,8))
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$x, 2:8)

    params$y_lim <- c(2,8)
    points <- Points$new(params)
    points$get_params()
    points$get_data()
    expect_equal(points$data$y, 2:8)
})
