scene=Scene:create()


local layer=Layer2D:create()
layer:setViewArea(0,0,960,640)

scene:push(layer)

jpeg_quad=Quad2D:create("matchModel.png")
jpeg_quad:setPosition(100,320)

png_quad=Quad2D:create("scale9.png",100,100)
png_quad:setPosition(300,320)


tga_quad=Quad2D:create("bob_helmet.tga",100,100)
tga_quad:setPosition(500,320)

tga_quad2=Quad2D:create("bob_body.tga",100,100)
tga_quad2:setPosition(700,320)


layer:add(jpeg_quad)
layer:add(png_quad)
layer:add(tga_quad)
layer:add(tga_quad2)






share:director():run(scene)





