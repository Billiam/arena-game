return function(spark, wall, collision)
  if collision.normal.x == 0 then
    spark.velocity.y = 0
  else
    spark.velocity.x = 0
  end
end