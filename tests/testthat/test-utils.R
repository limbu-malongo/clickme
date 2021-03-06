context("utils")

test_that("get_attrs", {
    my_list <- list(list(list(a = 1, b = 2, c = 3, d = 4), list(a = 5, b = 6, c = 7, d = 8)))
    my_attrs <- get_attrs(my_list, c("a", "d", "c"))
    expect_equal(my_attrs, list(list(list(a = 1, d = 4, c = 3), list(a = 5, d = 8, c = 7))))
})

test_that("get_tooltip_format", {
    tooltip_format <- get_tooltip_format(c("a", "b", "c"))
    expect_equal(tooltip_format, "s")

    tooltip_format <- get_tooltip_format(c(-1, 0, 1, 2, 3))
    expect_equal(tooltip_format, "s")

    tooltip_format <- get_tooltip_format(c(-2.3, 1.1, 2, 3))
    expect_equal(tooltip_format, ".2f")
})


test_that("data.frame.by.rows", {
    data <- data.frame.by.rows(1:3,4:6, row.names = c("A", "B"))
    expect_equal(data, data.frame(V1=c(1,4), V2=c(2,5), V3=c(3,6), row.names = c("A", "B")))
    data <- data.frame.by.rows(1:3,4:6, row.names = c("A", "B"))
    colnames(data) <- c("a", "b", "c")
    expect_equal(data, data.frame(a=c(1,4), b=c(2,5), c=c(3,6), row.names = c("A", "B")))
})

test_that("default_colors", {
    expect_equal(length(default_colors(15)), 15)
})

test_that("scale_type", {
    expect_equal(scale_type(NULL), "categorical")
    expect_equal(scale_type(c(1)), "categorical")
    expect_equal(scale_type(c("a")), "categorical")
    expect_equal(scale_type(c("a", "b", "c")), "categorical")
    expect_equal(scale_type(c(1, 2, 3)), "quantitative")
})

test_that("match_to_groups", {
    subset  <- c("w","b","p","e","j")
    groups <- list(a = letters[1:10], b = letters[11:20], c = letters[21:26])
    expect_equal(match_to_groups(subset, groups), c("c","a","b","a","a"))

    subset  <- c("w","b","A","B","j")
    expect_equal(match_to_groups(subset, groups, replace_nas = "Other"), c("c","a","Other","Other","a"))

    subset <- c("a","b","c")
    groups <- list(a = c("a","b"), b = c("a","b","c"))
    suppressWarnings(expect_equal(match_to_groups(subset, groups, strict_dups = FALSE), c("a","a","b")))
    expect_message(match_to_groups(subset, groups, strict_dups = FALSE), "The following elements appear in more than one group:\na\nb")
    expect_error(match_to_groups(subset, groups, strict_dups = TRUE), "The following elements appear in more than one group:\na\nb")
})


test_that("disjoint_sets", {
    a <- c(1:3,5)
    b <- c(0,2:4)
    expect_equal(disjoint_sets(a,b), list(a = c(1,5), b = c(0,4), both = c(2,3)))

    expect_equal(disjoint_sets(a,b, names = c("A", "B", "Both")), list(A = c(1,5), B = c(0,4), Both = c(2,3)))
})

test_that("extract_functions", {
    expressions <- c(" params$a ", "a")
    expect_true(length(extract_functions(expressions)) == 0)

    expressions <- c(" rjson::toJSON(paco) ", "clickme:::my_fun()")
    expect_true(length(extract_functions(expressions)) == 0)

    expressions <- c("a()", " myFun(b, b3) ", " my_fun2()  ", "my.fun3(a = 3)", ".my.fun4()")
    expect_equal(extract_functions(expressions), c("a", "myFun", "my_fun2", "my.fun3", ".my.fun4"))

})


test_that("title_case", {
    strings <- c("paco", "pepe")
    expect_equal(title_case(strings), c("Paco","Pepe"))
})

test_that("camel_case", {
    expect_equal(camel_case("paco_pepe"), "PacoPepe")
    expect_equal(camel_case("PacoPepe"), "PacoPepe")

    strings <- c("paco_pepe", "paco.pepe", "paco.pepe_luis")
    expect_equal(camel_case(strings), c("PacoPepe","PacoPepe", "PacoPepeLuis"))

    strings <- c("PacoPepe","PacoPepe", "PacoPepeLuis")
    expect_equal(camel_case(strings), c("PacoPepe","PacoPepe", "PacoPepeLuis"))
})

test_that("snake_case", {
    strings <- c("PacoPepe", "pacoPepe", "Paco")
    expect_equal(snake_case(strings), c("paco_pepe","paco_pepe", "paco"))
})

test_that("move_in_front", {
    files <- c("second", "first", "third")
    expect_equal(move_in_front("first", files), c("first", "second", "third"))

    expect_error(move_in_front("fake", files), "The following elements don't appear in \"files\":\n\tfake")
})


test_that("demo_mode", {
    options(clickme_demo_mode = NULL)
    expect_equal(demo_mode(), FALSE)
    expect_message(demo_mode(TRUE), "Demo mode on.")
    expect_equal(demo_mode(), TRUE)
    expect_message(demo_mode(FALSE), "Demo mode off.")
    expect_equal(demo_mode(), FALSE)
})