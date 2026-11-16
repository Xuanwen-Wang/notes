module attributes {zeus.br_spill_mode = "compiler-stack", zeus.parallel_executor_topology, zeus.required_num_dt = 4 : i64, zeus.required_num_vp = 4 : i64, zeus.siso_protocol = "zeus518"} {
  memref.global "private" constant @__sigmoid_inv_packed : memref<96xf32> = dense<[1.031250e+00, 1.062500e+00, 1.093750e+00, 1.125000e+00, 1.156250e+00, 1.187500e+00, 1.218750e+00, 1.250000e+00, 1.281250e+00, 1.312500e+00, 1.343750e+00, 1.375000e+00, 1.406250e+00, 1.437500e+00, 1.468750e+00, 1.500000e+00, 1.531250e+00, 1.562500e+00, 1.593750e+00, 1.625000e+00, 1.656250e+00, 1.687500e+00, 1.718750e+00, 1.750000e+00, 1.781250e+00, 1.812500e+00, 1.843750e+00, 1.875000e+00, 1.906250e+00, 1.937500e+00, 1.968750e+00, 1.968750e+00, -0.969695985, -9.126560e-01, -0.860504984, -8.126980e-01, -7.687680e-01, -7.283070e-01, -6.909570e-01, -0.656410038, -6.243900e-01, -5.946580e-01, -5.669980e-01, -5.412250e-01, -0.517170966, -4.946840e-01, -0.473635972, -0.453901023, -4.353730e-01, -4.179610e-01, -4.015680e-01, -3.861230e-01, -3.715520e-01, -3.577910e-01, -0.344780982, -3.324680e-01, -3.208020e-01, -0.309739023, -0.299240023, -2.892650e-01, -0.279780984, -2.707580e-01, -2.621600e-01, -2.539670e-01, 1.96969604, 1.91087306, 1.85546303, 1.80317402, 1.75375295, 1.706970e+00, 1.66261601, 1.62051296, 1.58048701, 1.54239404, 1.506090e+00, 1.471457, 1.43838298, 1.40676105, 1.37650394, 1.34751904, 1.31972694, 1.293064, 1.267450e+00, 1.24283397, 1.21915603, 1.196365, 1.17441106, 1.153247, 1.13283098, 1.11312699, 1.09409702, 1.07570601, 1.05792296, 1.04072201, 1.02406394, 1.00793397]>
  memref.global "private" constant @__packed_prg_lut : memref<192xf32> = dense<"0x53AD2A3CD6CFD93CA6831E3D84A8873D2C70973DD6D8A33D2D48A93D4B0BCF3DD172FC3D07AD133EFB16323ECBF34E3E2A07693EA1D6803E2B64833E29B5843E89F2843EE2F5843EE2FF8A3E22A28B3EC107903ECD13933E8128973E8D98983E3EE39D3E0EC1A83E2296B23EEF7EBF3ECC5FC13E547BC63E612BCA3EDBE2CC3E8AD9313F78D5333F8213353FC5FC373F35673B3FD7DD3A3F3EEE3A3FD5FA3C3F53D23F3F2486423F730B463F6B3A4A3F25F84D3F4993513F9532553F15A5523F26E7723F2D06ACBF775A553F50C2563FF005573FB61C583FAA1F593F5F545A3F4B735A3F75585D3FDB62603FB3EA633F6980683FB127673FD8FD683F1B35693FEFFF7F3FA5FA7F3F30F27F3F58D57F3F6C9B7F3F95A57F3F45A47F3FE8787F3F5D2F7F3F16DA7E3F1A587E3FD89D7D3F49DC7C3F360A7C3FDE207B3F92C87B3F206C733F78EAC53FBF147B3F0EB37A3F9CA07A3F30527A3FCE077A3FAAAC793F72A3793FE4BE783F55BE773F1283763F16CC743F484E753F0598743F3382743F9DAAD63E46F7E43E92DBF33E337C013F3838083FB0E60B3FAD920C3F7E8C0E3F68D9173FE84B203F8F36243FD5AF283F5AC12F3FD69E373FDC373C3FBA02403F0FC4453FF2A4483F08A04B3F9356533F860C5A3FAAF75A3F389E5F3FD1D7613F8AA7643F1432693FDF936E3FD103723F0D05733F4044753F38B17A3F0000000098696B3F6A7C6F3FFE5C743FD367793F19737E3FFB26813F72FF823FC2B1803F631F843F4F84873F95048A3F5B038B3F13518D3FF35F903F9213933F0244943FC461963FAA92983FF6BA983FE98C9B3F7ACE9E3FCAEBA03F4D85A13F0850A33F0FFCA33F76B0A53F7211A83F7D43AA3FC567AB3FCF64AB3FED91AD3F8039B03F4FA0733F16EB713FB9BC6F3FEB556D3FCBC86A3FADBB683F48B7663FE43E693F826D653FB066613FDC445E3F02FE5C3FD7F4593FE1C1553FBBE1513F1122503F63F54C3FC592493F9B53493F1CD7443FD4763F3FB2DC3B3F17D63A3FADB4373F2785363F9579333F1B242F3F850C2B3FE4E3283F84E9283F00BE243F088B1F3F">
  memref.global "private" constant @__constant_32xf32_4 : memref<32xf32> = dense<[1.041730e-02, 0.0265883617, 0.0386997685, 0.0662393867, 0.0739444196, 0.0800034255, 0.0826571956, 0.101095758, 0.12326587, 0.144214734, 0.173915789, 0.202101871, 0.227566391, 0.251637489, 0.256623596, 0.259194642, 0.259662896, 0.259688437, 0.271483481, 0.27272135, 0.281309158, 0.287260443, 0.295230895, 0.29803887, 0.308374345, 0.32959789, 0.348801672, 0.374015301, 3.776840e-01, 0.387659669, 0.394862205, 0.40016827]> {alignment = 16 : i64}
  memref.global "private" constant @__constant_32xf32_3 : memref<32xf32> = dense<[0.694725633, 7.024760e-01, 0.707328916, 0.718700706, 0.732043564, 0.729947507, 0.730197787, 0.738202393, 0.749303042, 0.759859324, 0.773612201, 0.789953887, 0.804567635, 0.818653643, 0.83280307, 0.822831451, 0.948839545, -1.34393847, 0.833411633, 0.838902473, 0.839934349, 0.844188094, 0.848139405, 0.8528499, 0.853321731, 0.864630997, 0.876508414, 0.890299975, 0.908209383, 0.902949392, 0.910123348, 0.910966575]> {alignment = 16 : i64}
  memref.global "private" constant @__constant_32xf32_2 : memref<32xf32> = dense<[0.999998986, 0.999918282, 0.999789237, 0.999349117, 0.998465299, 0.998620331, 0.998600304, 0.997938632, 0.996816456, 0.995515227, 0.993531823, 0.990689754, 0.987736284, 0.984530806, 0.980970263, 0.98352921, 0.950868606, 1.54621792, 0.98078531, 0.979294657, 0.979013204, 0.977816581, 0.97668159, 0.975290894, 0.975150227, 0.971662759, 0.967747986, 0.962937474, 0.956239104, 0.958225727, 0.955444633, 0.955111682]> {alignment = 16 : i64}
  memref.global "private" constant @__constant_32xf32_1 : memref<32xf32> = dense<[0.419270426, 0.447199047, 0.476284564, 0.50580138, 0.53210783, 0.546488762, 0.549113095, 0.556831241, 0.593161106, 0.626158237, 0.641457498, 0.658932983, 0.686544061, 0.717267394, 0.735227346, 0.750041604, 0.772522866, 0.783766865, 0.795410633, 0.825539767, 0.851753592, 0.855341553, 0.873507976, 0.882199347, 0.893181443, 0.910920382, 0.931943833, 0.945370733, 0.949295818, 0.958072662, 0.979266643, 0.000000e+00]> {alignment = 16 : i64}
  memref.global "private" constant @__constant_32xf32_0 : memref<32xf32> = dense<[0.919579982, 0.935492157, 0.954543948, 0.974240481, 0.99394375, 1.00900209, 1.02342057, 1.00542474, 1.03220785, 1.05872524, 1.07826483, 1.0860399, 1.10403669, 1.12792814, 1.14903474, 1.15832543, 1.17485857, 1.19197583, 1.1932056, 1.21523774, 1.24067616, 1.25719571, 1.26188052, 1.27587986, 1.28112972, 1.29444766, 1.31303239, 1.33018458, 1.33910429, 1.33901393, 1.3560158, 1.37675476]> {alignment = 16 : i64}
  memref.global "private" constant @__constant_32xf32 : memref<32xf32> = dense<[0.951664865, 0.944993376, 0.936473429, 0.927092254, 0.917126357, 0.909113705, 0.901234149, 0.911115885, 0.896202206, 0.880473136, 0.868238211, 0.863250851, 0.851392209, 0.834989607, 0.819850623, 0.813019812, 0.800619304, 0.787395775, 0.786431968, 0.768907309, 0.747906923, 0.733836293, 0.729829251, 0.717600643, 0.712969243, 0.701073944, 0.684144675, 0.668159782, 0.659727335, 0.659813166, 0.643524169, 0.623215198]> {alignment = 16 : i64}
  func.func @sgl_moe_router_linear_biased_topk_kernel_bf16(%arg0: memref<*xbf16>, %arg1: memref<*xi64>, %arg2: memref<*xf32>, %arg3: memref<*xbf16>, %arg4: memref<*xi32>, %arg5: memref<*xf32>, %arg6: memref<*xf32>, %arg7: f32, %arg8: memref<*xf32>, %arg9: memref<*xf32>, %arg10: memref<*xf32>, %arg11: memref<*xf32>, %arg12: i32 {zeus.program_id}) attributes {zeus.num_cores = 2 : i32, zeus.parallel_executor} {
    %c3 = arith.constant 3 : index
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %c32_i32 = arith.constant 32 : i32
    %c4096 = arith.constant 4096 : index
    %c8 = arith.constant 8 : index
    %c4 = arith.constant 4 : index
    %c0_i32 = arith.constant 0 : i32
    %c16_i32 = arith.constant 16 : i32
    %c4_i32 = arith.constant 4 : i32
    %c8_i32 = arith.constant 8 : i32
    %0 = zeus_high.load_weight_addr %arg1, %arg12 : memref<*xi64>, i32 -> memref<1xbf16>
    %1 = zeus_high.create_weight_desc %0 {offset = 0, tensor_shape = [1, 320, 4096], tile_shape = [1, 320, 4096], blocked_offset = %c0_i32, memory_space = "LDG"} : memref<1xbf16> -> !zeus_high.weight_desc
    %alloc = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %2 = zeus_high.create_fmap_desc %alloc {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %3 = zeus_high.create_fmap_desc %arg2 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<*xf32> -> !zeus_high.fmap_desc
    %4 = zeus_high.set_pos %3 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %5 = zeus_high.set_pos %2 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.load %arg2, %alloc desc(%4, %5) : memref<*xf32>, memref<1x1x1x320xf32>
    %6 = arith.muli %arg12, %c4_i32 : i32
    %7 = arith.index_cast %6 : i32 to index
    %8 = arith.addi %6, %c8_i32 : i32
    %9 = arith.index_cast %8 : i32 to index
    %10 = arith.addi %6, %c16_i32 : i32
    %11 = arith.index_cast %10 : i32 to index
    %12 = arith.muli %7, %c4096 : index
    %alloc_0 = memref.alloc() {alignment = 16 : i64} : memref<1x1x4x4096xbf16>
    %13 = zeus_high.create_fmap_desc %alloc_0 {offset = 0, tensor_shape = [1, 1, 4, 4096], tile_shape = [1, 1, 4, 4096]} : memref<1x1x4x4096xbf16> -> !zeus_high.fmap_desc
    %14 = zeus_high.create_fmap_desc %arg0 {offset = 0, tensor_shape = [1, 1, 4, 4096], tile_shape = [1, 1, 4, 4096], dynamic_byte_offset = %12} : memref<*xbf16> -> !zeus_high.fmap_desc
    %15 = zeus_high.set_pos %14 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %16 = zeus_high.set_pos %13 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.load %arg0, %alloc_0 desc(%15, %16) : memref<*xbf16>, memref<1x1x4x4096xbf16>
    %alloc_1 = memref.alloc() {alignment = 16 : i64} : memref<1x1x4x320xbf16>
    %17 = zeus_high.create_fmap_desc %alloc_1 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 4, 320]} : memref<1x1x4x320xbf16> -> !zeus_high.fmap_desc
    %18 = zeus_high.set_pos %1 [0, 0, 0] : !zeus_high.weight_desc -> !zeus_high.weight_desc
    zeus_high.pe %alloc_0, %0, %alloc_1 desc(%16, %18, %17) {mtc = 16 : i64, mtk = 1 : i64, mtw = 4 : i64, op_type = "matmul", transpose_lhs = false, transpose_rhs = false, wbs = 320 : i64, ymode = "KC"} : memref<1x1x4x4096xbf16>, memref<1xbf16>, memref<1x1x4x320xbf16>
    memref.dealloc %alloc_0 : memref<1x1x4x4096xbf16>
    %19 = arith.muli %9, %c4096 : index
    %alloc_2 = memref.alloc() {alignment = 16 : i64} : memref<1x1x4x4096xbf16>
    %20 = zeus_high.create_fmap_desc %alloc_2 {offset = 0, tensor_shape = [1, 1, 4, 4096], tile_shape = [1, 1, 4, 4096]} : memref<1x1x4x4096xbf16> -> !zeus_high.fmap_desc
    %21 = zeus_high.create_fmap_desc %arg0 {offset = 0, tensor_shape = [1, 1, 4, 4096], tile_shape = [1, 1, 4, 4096], dynamic_byte_offset = %19} : memref<*xbf16> -> !zeus_high.fmap_desc
    %22 = zeus_high.set_pos %21 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %23 = zeus_high.set_pos %20 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.load %arg0, %alloc_2 desc(%22, %23) : memref<*xbf16>, memref<1x1x4x4096xbf16>
    %alloc_3 = memref.alloc() {alignment = 16 : i64} : memref<1x1x4x320xbf16>
    %24 = zeus_high.create_fmap_desc %alloc_3 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 4, 320]} : memref<1x1x4x320xbf16> -> !zeus_high.fmap_desc
    zeus_high.pe %alloc_2, %0, %alloc_3 desc(%23, %18, %24) {mtc = 16 : i64, mtk = 1 : i64, mtw = 4 : i64, op_type = "matmul", transpose_lhs = false, transpose_rhs = false, wbs = 320 : i64, ymode = "KC"} : memref<1x1x4x4096xbf16>, memref<1xbf16>, memref<1x1x4x320xbf16>
    memref.dealloc %alloc_2 : memref<1x1x4x4096xbf16>
    %25 = arith.muli %11, %c4096 : index
    %alloc_4 = memref.alloc() {alignment = 16 : i64} : memref<1x1x4x4096xbf16>
    %26 = zeus_high.create_fmap_desc %alloc_4 {offset = 0, tensor_shape = [1, 1, 4, 4096], tile_shape = [1, 1, 4, 4096]} : memref<1x1x4x4096xbf16> -> !zeus_high.fmap_desc
    %27 = zeus_high.create_fmap_desc %arg0 {offset = 0, tensor_shape = [1, 1, 4, 4096], tile_shape = [1, 1, 4, 4096], dynamic_byte_offset = %25} : memref<*xbf16> -> !zeus_high.fmap_desc
    %28 = zeus_high.set_pos %27 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %29 = zeus_high.set_pos %26 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.load %arg0, %alloc_4 desc(%28, %29) : memref<*xbf16>, memref<1x1x4x4096xbf16>
    %alloc_5 = memref.alloc() {alignment = 16 : i64} : memref<1x1x4x320xbf16>
    %30 = zeus_high.create_fmap_desc %alloc_5 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 4, 320]} : memref<1x1x4x320xbf16> -> !zeus_high.fmap_desc
    zeus_high.pe %alloc_4, %0, %alloc_5 desc(%29, %18, %30) {mtc = 16 : i64, mtk = 1 : i64, mtw = 4 : i64, op_type = "matmul", transpose_lhs = false, transpose_rhs = false, wbs = 320 : i64, ymode = "KC"} : memref<1x1x4x4096xbf16>, memref<1xbf16>, memref<1x1x4x320xbf16>
    memref.dealloc %alloc_4 : memref<1x1x4x4096xbf16>
    %alloc_6 = memref.alloc() {alignment = 16 : i64, zeus_high.in_place_iter_arg} : memref<1x1x4x8xbf16>
    %31 = zeus_high.create_fmap_desc %alloc_6 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 4, 8]} : memref<1x1x4x8xbf16> -> !zeus_high.fmap_desc
    %alloc_7 = memref.alloc() {alignment = 16 : i64, zeus_high.in_place_iter_arg} : memref<1x1x4x8xbf16>
    %32 = zeus_high.create_fmap_desc %alloc_7 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 4, 8]} : memref<1x1x4x8xbf16> -> !zeus_high.fmap_desc
    %alloc_8 = memref.alloc() {alignment = 16 : i64, zeus_high.in_place_iter_arg} : memref<1x1x4x8xbf16>
    %33 = zeus_high.create_fmap_desc %alloc_8 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 4, 8]} : memref<1x1x4x8xbf16> -> !zeus_high.fmap_desc
    %alloc_9 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_tag = "topk_packet_destination_0", zeus_high.in_place_iter_arg} : memref<1x1x4x32xi32>
    %34 = zeus_high.create_fmap_desc %alloc_9 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 4, 32]} : memref<1x1x4x32xi32> -> !zeus_high.fmap_desc
    %alloc_10 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_tag = "topk_packet_destination_1", zeus_high.in_place_iter_arg} : memref<1x1x4x32xi32>
    %35 = zeus_high.create_fmap_desc %alloc_10 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 4, 32]} : memref<1x1x4x32xi32> -> !zeus_high.fmap_desc
    %alloc_11 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_tag = "topk_packet_destination_2", zeus_high.in_place_iter_arg} : memref<1x1x4x32xi32>
    %36 = zeus_high.create_fmap_desc %alloc_11 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 4, 32]} : memref<1x1x4x32xi32> -> !zeus_high.fmap_desc
    %alloc_12 = memref.alloc() : memref<1x1x1x192xf32>
    %37 = zeus_high.create_fmap_desc %alloc_12 {offset = 0, tensor_shape = [1, 1, 1, 192], tile_shape = [1, 1, 1, 192]} : memref<1x1x1x192xf32> -> !zeus_high.fmap_desc
    %38 = memref.get_global @__packed_prg_lut : memref<192xf32>
    %39 = zeus_high.create_fmap_desc %38 {offset = 0, tensor_shape = [1, 1, 1, 192], tile_shape = [1, 1, 1, 192]} : memref<192xf32> -> !zeus_high.fmap_desc
    %40 = zeus_high.set_pos %39 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %41 = zeus_high.set_pos %37 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.load %38, %alloc_12 desc(%40, %41) : memref<192xf32>, memref<1x1x1x192xf32>
    %alloc_13 = memref.alloc() : memref<1x1x1x192xf32>
    %42 = zeus_high.create_fmap_desc %alloc_13 {offset = 0, tensor_shape = [1, 1, 1, 192], tile_shape = [1, 1, 1, 192]} : memref<1x1x1x192xf32> -> !zeus_high.fmap_desc
    %43 = zeus_high.create_fmap_desc %38 {offset = 0, tensor_shape = [1, 1, 1, 192], tile_shape = [1, 1, 1, 192]} : memref<192xf32> -> !zeus_high.fmap_desc
    %44 = zeus_high.set_pos %43 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %45 = zeus_high.set_pos %42 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.load %38, %alloc_13 desc(%44, %45) : memref<192xf32>, memref<1x1x1x192xf32>
    %alloc_14 = memref.alloc() : memref<1x1x1x192xf32>
    %46 = zeus_high.create_fmap_desc %alloc_14 {offset = 0, tensor_shape = [1, 1, 1, 192], tile_shape = [1, 1, 1, 192]} : memref<1x1x1x192xf32> -> !zeus_high.fmap_desc
    %47 = zeus_high.create_fmap_desc %38 {offset = 0, tensor_shape = [1, 1, 1, 192], tile_shape = [1, 1, 1, 192]} : memref<192xf32> -> !zeus_high.fmap_desc
    %48 = zeus_high.set_pos %47 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %49 = zeus_high.set_pos %46 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.load %38, %alloc_14 desc(%48, %49) : memref<192xf32>, memref<1x1x1x192xf32>
    %subview = memref.subview %alloc_1[0, 0, 0, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1]>>
    %cast = memref.cast %subview : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1]>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %subview_15 = memref.subview %alloc_1[0, 0, 1, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 320>>
    %cast_16 = memref.cast %subview_15 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 320>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %subview_17 = memref.subview %alloc_1[0, 0, 2, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 640>>
    %cast_18 = memref.cast %subview_17 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 640>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %subview_19 = memref.subview %alloc_1[0, 0, 3, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 960>>
    %cast_20 = memref.cast %subview_19 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 960>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %50 = zeus_high.create_fmap_desc %cast {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %51 = zeus_high.create_fmap_desc %cast_16 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %52 = zeus_high.create_fmap_desc %cast_18 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %53 = zeus_high.create_fmap_desc %cast_20 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %54 = zeus_high.set_pos %50 [0, 0, %c0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %55 = zeus_high.set_pos %51 [0, 0, %c1, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %56 = zeus_high.set_pos %52 [0, 0, %c2, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %57 = zeus_high.set_pos %53 [0, 0, %c3, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %alloc_21 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_22 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_23 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_24 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %58 = zeus_high.create_fmap_desc %alloc_21 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %59 = zeus_high.create_fmap_desc %alloc_22 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %60 = zeus_high.create_fmap_desc %alloc_23 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %61 = zeus_high.create_fmap_desc %alloc_24 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %cast, %alloc_21 desc(%54, %58) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_16, %alloc_22 desc(%55, %59) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_18, %alloc_23 desc(%56, %60) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_20, %alloc_24 desc(%57, %61) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    %alloc_25 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_26 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_27 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_28 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %62 = zeus_high.create_fmap_desc %alloc_25 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %63 = zeus_high.create_fmap_desc %alloc_26 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %64 = zeus_high.create_fmap_desc %alloc_27 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %65 = zeus_high.create_fmap_desc %alloc_28 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %cast, %alloc_25 desc(%54, %62) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_16, %alloc_26 desc(%55, %63) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_18, %alloc_27 desc(%56, %64) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_20, %alloc_28 desc(%57, %65) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    %alloc_29 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_30 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_31 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_32 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %66 = zeus_high.create_fmap_desc %alloc_29 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %67 = zeus_high.create_fmap_desc %alloc_30 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %68 = zeus_high.create_fmap_desc %alloc_31 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %69 = zeus_high.create_fmap_desc %alloc_32 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_12, %alloc_12 desc(%37, %37) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %alloc_12, %alloc_12 desc(%37, %37) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %alloc_12, %alloc_12 desc(%37, %37) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %alloc_12, %alloc_12 desc(%37, %37) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %cast, %alloc_29 desc(%54, %66) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_16, %alloc_30 desc(%55, %67) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_18, %alloc_31 desc(%56, %68) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_20, %alloc_32 desc(%57, %69) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_1 : memref<1x1x4x320xbf16>
    memref.dealloc %alloc_12 : memref<1x1x1x192xf32>
    zeus_high.vp %alloc_21, %alloc_21 desc(%58, %58) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_22, %alloc_22 desc(%59, %59) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_23, %alloc_23 desc(%60, %60) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_24, %alloc_24 desc(%61, %61) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_29, %alloc_29 desc(%66, %66) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_30, %alloc_30 desc(%67, %67) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_31, %alloc_31 desc(%68, %68) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_32, %alloc_32 desc(%69, %69) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    %70 = memref.get_global @__sigmoid_inv_packed : memref<96xf32>
    %alloc_33 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %alloc_34 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %alloc_35 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %alloc_36 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %71 = zeus_high.create_fmap_desc %alloc_33 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %72 = zeus_high.create_fmap_desc %alloc_34 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %73 = zeus_high.create_fmap_desc %alloc_35 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %74 = zeus_high.create_fmap_desc %alloc_36 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %75 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %76 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %77 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %78 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %79 = zeus_high.set_pos %75 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %80 = zeus_high.set_pos %76 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %81 = zeus_high.set_pos %77 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %82 = zeus_high.set_pos %78 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %83 = zeus_high.set_pos %71 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %84 = zeus_high.set_pos %72 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %85 = zeus_high.set_pos %73 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %86 = zeus_high.set_pos %74 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.load %70, %alloc_33 desc(%79, %83) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_33, %alloc_33 desc(%71, %71) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    zeus_high.load %70, %alloc_34 desc(%80, %84) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_34, %alloc_34 desc(%72, %72) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    zeus_high.load %70, %alloc_35 desc(%81, %85) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_35, %alloc_35 desc(%73, %73) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    zeus_high.load %70, %alloc_36 desc(%82, %86) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_36, %alloc_36 desc(%74, %74) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    memref.dealloc %alloc_33 : memref<1x1x1x96xf32>
    memref.dealloc %alloc_34 : memref<1x1x1x96xf32>
    memref.dealloc %alloc_35 : memref<1x1x1x96xf32>
    memref.dealloc %alloc_36 : memref<1x1x1x96xf32>
    %alloc_37 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_38 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_39 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_40 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %87 = zeus_high.create_fmap_desc %alloc_37 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %88 = zeus_high.create_fmap_desc %alloc_38 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %89 = zeus_high.create_fmap_desc %alloc_39 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %90 = zeus_high.create_fmap_desc %alloc_40 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_21, %alloc_37 desc(%58, %87) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_22, %alloc_38 desc(%59, %88) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_23, %alloc_39 desc(%60, %89) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_24, %alloc_40 desc(%61, %90) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_21, %alloc_37, %alloc_21 desc(%58, %87, %58) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_22, %alloc_38, %alloc_22 desc(%59, %88, %59) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_23, %alloc_39, %alloc_23 desc(%60, %89, %60) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_24, %alloc_40, %alloc_24 desc(%61, %90, %61) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_37, %alloc_21, %alloc_37 desc(%87, %58, %87) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_21 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_38, %alloc_22, %alloc_38 desc(%88, %59, %88) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_22 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_39, %alloc_23, %alloc_39 desc(%89, %60, %89) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_23 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_40, %alloc_24, %alloc_40 desc(%90, %61, %90) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_24 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_29, %alloc_25, %alloc_29 desc(%66, %62, %66) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_30, %alloc_26, %alloc_30 desc(%67, %63, %67) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_31, %alloc_27, %alloc_31 desc(%68, %64, %68) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_32, %alloc_28, %alloc_32 desc(%69, %65, %69) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_37, %alloc_25, %alloc_37 desc(%87, %62, %87) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_25 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_38, %alloc_26, %alloc_38 desc(%88, %63, %88) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_26 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_39, %alloc_27, %alloc_39 desc(%89, %64, %89) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_27 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_40, %alloc_28, %alloc_40 desc(%90, %65, %90) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_28 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_29, %alloc_37, %alloc_29 desc(%66, %87, %66) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_37 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_30, %alloc_38, %alloc_30 desc(%67, %88, %67) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_38 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_31, %alloc_39, %alloc_31 desc(%68, %89, %68) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_39 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_32, %alloc_40, %alloc_32 desc(%69, %90, %69) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_40 : memref<1x1x1x320xf32>
    %alloc_41 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_42 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_43 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_44 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %91 = zeus_high.create_fmap_desc %alloc_41 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %92 = zeus_high.create_fmap_desc %alloc_42 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %93 = zeus_high.create_fmap_desc %alloc_43 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %94 = zeus_high.create_fmap_desc %alloc_44 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_29, %alloc, %alloc_41 desc(%66, %5, %91) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_30, %alloc, %alloc_42 desc(%67, %5, %92) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_31, %alloc, %alloc_43 desc(%68, %5, %93) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_32, %alloc, %alloc_44 desc(%69, %5, %94) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    %alloc_45 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655560043008_lane0, zeus.topk_pair_id = 94655559230160 : i64} : memref<1x1x1x32xi32>
    %alloc_46 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655560043008_lane1, zeus.topk_pair_id = 94655559230160 : i64} : memref<1x1x1x32xi32>
    %alloc_47 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655560043008_lane2, zeus.topk_pair_id = 94655559230160 : i64} : memref<1x1x1x32xi32>
    %alloc_48 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655560043008_lane3, zeus.topk_pair_id = 94655559230160 : i64} : memref<1x1x1x32xi32>
    %95 = zeus_high.create_fmap_desc %alloc_45 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_45 : memref<1x1x1x32xi32>
    %96 = zeus_high.create_fmap_desc %alloc_46 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_46 : memref<1x1x1x32xi32>
    %97 = zeus_high.create_fmap_desc %alloc_47 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_47 : memref<1x1x1x32xi32>
    %98 = zeus_high.create_fmap_desc %alloc_48 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_48 : memref<1x1x1x32xi32>
    %alloc_49 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655560043008_lane0, zeus.topk_pair_id = 94655559230160 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %alloc_50 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655560043008_lane1, zeus.topk_pair_id = 94655559230160 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %alloc_51 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655560043008_lane2, zeus.topk_pair_id = 94655559230160 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %alloc_52 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655560043008_lane3, zeus.topk_pair_id = 94655559230160 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %99 = zeus_high.create_fmap_desc %alloc_49 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    %100 = zeus_high.create_fmap_desc %alloc_50 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    %101 = zeus_high.create_fmap_desc %alloc_51 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    %102 = zeus_high.create_fmap_desc %alloc_52 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    %alloc_53 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_packet_destination_0, zeus.l2_alias_tag = "topk_vp_result_94655560043008_lane0"} : memref<1x1x1x32xf32>
    %alloc_54 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 128 : i64, zeus.l2_alias_of = @topk_packet_destination_0, zeus.l2_alias_tag = "topk_vp_result_94655560043008_lane1"} : memref<1x1x1x32xf32>
    %alloc_55 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 256 : i64, zeus.l2_alias_of = @topk_packet_destination_0, zeus.l2_alias_tag = "topk_vp_result_94655560043008_lane2"} : memref<1x1x1x32xf32>
    %alloc_56 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 384 : i64, zeus.l2_alias_of = @topk_packet_destination_0, zeus.l2_alias_tag = "topk_vp_result_94655560043008_lane3"} : memref<1x1x1x32xf32>
    %103 = zeus_high.create_fmap_desc %alloc_53 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %104 = zeus_high.create_fmap_desc %alloc_54 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %105 = zeus_high.create_fmap_desc %alloc_55 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %106 = zeus_high.create_fmap_desc %alloc_56 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_41, %alloc_53 desc(%91, %103) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_42, %alloc_54 desc(%92, %104) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_43, %alloc_55 desc(%93, %105) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_44, %alloc_56 desc(%94, %106) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_41, %alloc_53 desc(%91, %103) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_42, %alloc_54 desc(%92, %104) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_43, %alloc_55 desc(%93, %105) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_44, %alloc_56 desc(%94, %106) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_41, %alloc_53 desc(%91, %103) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_42, %alloc_54 desc(%92, %104) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_43, %alloc_55 desc(%93, %105) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_44, %alloc_56 desc(%94, %106) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    %alloc_57 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %107 = zeus_high.create_fmap_desc %alloc_57 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %alloc_58 = memref.alloc() {alignment = 128 : i64, zeus.l2_alias_tag = "topk_stream_0"} : memref<1x1x1x32xf32>
    %108 = zeus_high.create_fmap_desc %alloc_58 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %alloc_59 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_stream_0} : memref<1x1x1x8xi32>
    %109 = zeus_high.create_fmap_desc %alloc_59 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_41, %alloc_58 desc(%91, %108) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = false, tkv = 3 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    %alloc_60 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %110 = zeus_high.create_fmap_desc %alloc_60 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %alloc_61 = memref.alloc() {alignment = 128 : i64, zeus.l2_alias_tag = "topk_stream_1"} : memref<1x1x1x32xf32>
    %111 = zeus_high.create_fmap_desc %alloc_61 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %alloc_62 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_stream_1} : memref<1x1x1x8xi32>
    %112 = zeus_high.create_fmap_desc %alloc_62 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_42, %alloc_61 desc(%92, %111) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = false, tkv = 3 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    %alloc_63 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %113 = zeus_high.create_fmap_desc %alloc_63 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %alloc_64 = memref.alloc() {alignment = 128 : i64, zeus.l2_alias_tag = "topk_stream_2"} : memref<1x1x1x32xf32>
    %114 = zeus_high.create_fmap_desc %alloc_64 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %alloc_65 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_stream_2} : memref<1x1x1x8xi32>
    %115 = zeus_high.create_fmap_desc %alloc_65 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_43, %alloc_64 desc(%93, %114) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = false, tkv = 3 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    %alloc_66 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %116 = zeus_high.create_fmap_desc %alloc_66 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %alloc_67 = memref.alloc() {alignment = 128 : i64, zeus.l2_alias_tag = "topk_stream_3"} : memref<1x1x1x32xf32>
    %117 = zeus_high.create_fmap_desc %alloc_67 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %alloc_68 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_stream_3} : memref<1x1x1x8xi32>
    %118 = zeus_high.create_fmap_desc %alloc_68 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_44, %alloc_67 desc(%94, %117) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = false, tkv = 3 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_41, %alloc_53 desc(%91, %103) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_42, %alloc_54 desc(%92, %104) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_43, %alloc_55 desc(%93, %105) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_44, %alloc_56 desc(%94, %106) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_41, %alloc_53 desc(%91, %103) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_42, %alloc_54 desc(%92, %104) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_43, %alloc_55 desc(%93, %105) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_44, %alloc_56 desc(%94, %106) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_41, %alloc_53 desc(%91, %103) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_42, %alloc_54 desc(%92, %104) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_43, %alloc_55 desc(%93, %105) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_44, %alloc_56 desc(%94, %106) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_41, %alloc_53 desc(%91, %103) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_53 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_41 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_42, %alloc_54 desc(%92, %104) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_54 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_42 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_43, %alloc_55 desc(%93, %105) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_55 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_43 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_44, %alloc_56 desc(%94, %106) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_56 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_44 : memref<1x1x1x320xf32>
    %subview_69 = memref.subview %alloc_9[0, 0, 0, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1]>>
    %cast_70 = memref.cast %subview_69 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1]>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %subview_71 = memref.subview %alloc_9[0, 0, 1, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 32>>
    %cast_72 = memref.cast %subview_71 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 32>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %subview_73 = memref.subview %alloc_9[0, 0, 2, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 64>>
    %cast_74 = memref.cast %subview_73 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 64>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %subview_75 = memref.subview %alloc_9[0, 0, 3, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 96>>
    %cast_76 = memref.cast %subview_75 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 96>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %119 = zeus_high.create_fmap_desc %cast_70 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %120 = zeus_high.create_fmap_desc %cast_72 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %121 = zeus_high.create_fmap_desc %cast_74 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %122 = zeus_high.create_fmap_desc %cast_76 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %subview_77 = memref.subview %alloc_3[0, 0, 0, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1]>>
    %cast_78 = memref.cast %subview_77 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1]>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %subview_79 = memref.subview %alloc_3[0, 0, 1, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 320>>
    %cast_80 = memref.cast %subview_79 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 320>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %subview_81 = memref.subview %alloc_3[0, 0, 2, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 640>>
    %cast_82 = memref.cast %subview_81 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 640>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %subview_83 = memref.subview %alloc_3[0, 0, 3, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 960>>
    %cast_84 = memref.cast %subview_83 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 960>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %123 = zeus_high.create_fmap_desc %cast_78 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %124 = zeus_high.create_fmap_desc %cast_80 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %125 = zeus_high.create_fmap_desc %cast_82 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %126 = zeus_high.create_fmap_desc %cast_84 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %127 = zeus_high.set_pos %123 [0, 0, %c0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %128 = zeus_high.set_pos %124 [0, 0, %c1, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %129 = zeus_high.set_pos %125 [0, 0, %c2, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %130 = zeus_high.set_pos %126 [0, 0, %c3, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %alloc_85 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_86 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_87 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_88 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %131 = zeus_high.create_fmap_desc %alloc_85 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %132 = zeus_high.create_fmap_desc %alloc_86 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %133 = zeus_high.create_fmap_desc %alloc_87 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %134 = zeus_high.create_fmap_desc %alloc_88 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %cast_78, %alloc_85 desc(%127, %131) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_80, %alloc_86 desc(%128, %132) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_82, %alloc_87 desc(%129, %133) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_84, %alloc_88 desc(%130, %134) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    %subview_89 = memref.subview %alloc_59[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>
    %subview_90 = memref.subview %alloc_57[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    zeus_high.gather %alloc_29, idx %subview_89, out %subview_90, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    memref.dealloc %alloc_59 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_58 : memref<1x1x1x32xf32>
    %alloc_91 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_92 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_93 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_94 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %135 = zeus_high.create_fmap_desc %alloc_91 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %136 = zeus_high.create_fmap_desc %alloc_92 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %137 = zeus_high.create_fmap_desc %alloc_93 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %138 = zeus_high.create_fmap_desc %alloc_94 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %cast_78, %alloc_91 desc(%127, %135) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_80, %alloc_92 desc(%128, %136) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_82, %alloc_93 desc(%129, %137) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_84, %alloc_94 desc(%130, %138) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    %subview_95 = memref.subview %alloc_62[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>
    %subview_96 = memref.subview %alloc_60[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    zeus_high.gather %alloc_30, idx %subview_95, out %subview_96, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    memref.dealloc %alloc_62 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_61 : memref<1x1x1x32xf32>
    %alloc_97 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_98 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_99 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_100 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %139 = zeus_high.create_fmap_desc %alloc_97 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %140 = zeus_high.create_fmap_desc %alloc_98 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %141 = zeus_high.create_fmap_desc %alloc_99 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %142 = zeus_high.create_fmap_desc %alloc_100 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_13, %alloc_13 desc(%42, %42) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %alloc_13, %alloc_13 desc(%42, %42) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %alloc_13, %alloc_13 desc(%42, %42) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %alloc_13, %alloc_13 desc(%42, %42) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    %subview_101 = memref.subview %alloc_65[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>
    %subview_102 = memref.subview %alloc_63[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    zeus_high.gather %alloc_31, idx %subview_101, out %subview_102, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    memref.dealloc %alloc_65 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_64 : memref<1x1x1x32xf32>
    zeus_high.vp %cast_78, %alloc_97 desc(%127, %139) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_80, %alloc_98 desc(%128, %140) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_82, %alloc_99 desc(%129, %141) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_84, %alloc_100 desc(%130, %142) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    %subview_103 = memref.subview %alloc_68[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>
    %subview_104 = memref.subview %alloc_66[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    zeus_high.gather %alloc_32, idx %subview_103, out %subview_104, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    memref.dealloc %alloc_68 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_67 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_3 : memref<1x1x4x320xbf16>
    memref.dealloc %alloc_13 : memref<1x1x1x192xf32>
    zeus_high.vp %alloc_85, %alloc_85 desc(%131, %131) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_86, %alloc_86 desc(%132, %132) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_87, %alloc_87 desc(%133, %133) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_88, %alloc_88 desc(%134, %134) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_97, %alloc_97 desc(%139, %139) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_98, %alloc_98 desc(%140, %140) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_99, %alloc_99 desc(%141, %141) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_100, %alloc_100 desc(%142, %142) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    %alloc_105 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %alloc_106 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %alloc_107 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %alloc_108 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %143 = zeus_high.create_fmap_desc %alloc_105 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %144 = zeus_high.create_fmap_desc %alloc_106 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %145 = zeus_high.create_fmap_desc %alloc_107 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %146 = zeus_high.create_fmap_desc %alloc_108 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %147 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %148 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %149 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %150 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %151 = zeus_high.set_pos %147 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %152 = zeus_high.set_pos %148 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %153 = zeus_high.set_pos %149 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %154 = zeus_high.set_pos %150 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %155 = zeus_high.set_pos %143 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %156 = zeus_high.set_pos %144 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %157 = zeus_high.set_pos %145 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %158 = zeus_high.set_pos %146 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.load %70, %alloc_105 desc(%151, %155) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_105, %alloc_105 desc(%143, %143) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    zeus_high.load %70, %alloc_106 desc(%152, %156) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_106, %alloc_106 desc(%144, %144) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    zeus_high.load %70, %alloc_107 desc(%153, %157) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_107, %alloc_107 desc(%145, %145) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    zeus_high.load %70, %alloc_108 desc(%154, %158) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_108, %alloc_108 desc(%146, %146) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    memref.dealloc %alloc_105 : memref<1x1x1x96xf32>
    memref.dealloc %alloc_106 : memref<1x1x1x96xf32>
    memref.dealloc %alloc_107 : memref<1x1x1x96xf32>
    memref.dealloc %alloc_108 : memref<1x1x1x96xf32>
    %alloc_109 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_110 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_111 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_112 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %159 = zeus_high.create_fmap_desc %alloc_109 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %160 = zeus_high.create_fmap_desc %alloc_110 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %161 = zeus_high.create_fmap_desc %alloc_111 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %162 = zeus_high.create_fmap_desc %alloc_112 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_85, %alloc_109 desc(%131, %159) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_86, %alloc_110 desc(%132, %160) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_87, %alloc_111 desc(%133, %161) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_88, %alloc_112 desc(%134, %162) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_85, %alloc_109, %alloc_85 desc(%131, %159, %131) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_86, %alloc_110, %alloc_86 desc(%132, %160, %132) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_87, %alloc_111, %alloc_87 desc(%133, %161, %133) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_88, %alloc_112, %alloc_88 desc(%134, %162, %134) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_109, %alloc_85, %alloc_109 desc(%159, %131, %159) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_85 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_110, %alloc_86, %alloc_110 desc(%160, %132, %160) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_86 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_111, %alloc_87, %alloc_111 desc(%161, %133, %161) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_87 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_112, %alloc_88, %alloc_112 desc(%162, %134, %162) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_88 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_97, %alloc_91, %alloc_97 desc(%139, %135, %139) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_98, %alloc_92, %alloc_98 desc(%140, %136, %140) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_99, %alloc_93, %alloc_99 desc(%141, %137, %141) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_100, %alloc_94, %alloc_100 desc(%142, %138, %142) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_109, %alloc_91, %alloc_109 desc(%159, %135, %159) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_91 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_110, %alloc_92, %alloc_110 desc(%160, %136, %160) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_92 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_111, %alloc_93, %alloc_111 desc(%161, %137, %161) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_93 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_112, %alloc_94, %alloc_112 desc(%162, %138, %162) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_94 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_97, %alloc_109, %alloc_97 desc(%139, %159, %139) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_109 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_98, %alloc_110, %alloc_98 desc(%140, %160, %140) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_110 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_99, %alloc_111, %alloc_99 desc(%141, %161, %141) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_111 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_100, %alloc_112, %alloc_100 desc(%142, %162, %142) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_112 : memref<1x1x1x320xf32>
    %alloc_113 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_114 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_115 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_116 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %163 = zeus_high.create_fmap_desc %alloc_113 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %164 = zeus_high.create_fmap_desc %alloc_114 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %165 = zeus_high.create_fmap_desc %alloc_115 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %166 = zeus_high.create_fmap_desc %alloc_116 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_97, %alloc, %alloc_113 desc(%139, %5, %163) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_98, %alloc, %alloc_114 desc(%140, %5, %164) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_99, %alloc, %alloc_115 desc(%141, %5, %165) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_100, %alloc, %alloc_116 desc(%142, %5, %166) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    %alloc_117 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_packet_destination_1, zeus.l2_alias_tag = "topk_vp_result_94655559961184_lane0"} : memref<1x1x1x32xf32>
    %alloc_118 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 128 : i64, zeus.l2_alias_of = @topk_packet_destination_1, zeus.l2_alias_tag = "topk_vp_result_94655559961184_lane1"} : memref<1x1x1x32xf32>
    %alloc_119 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 256 : i64, zeus.l2_alias_of = @topk_packet_destination_1, zeus.l2_alias_tag = "topk_vp_result_94655559961184_lane2"} : memref<1x1x1x32xf32>
    %alloc_120 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 384 : i64, zeus.l2_alias_of = @topk_packet_destination_1, zeus.l2_alias_tag = "topk_vp_result_94655559961184_lane3"} : memref<1x1x1x32xf32>
    %167 = zeus_high.create_fmap_desc %alloc_117 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %168 = zeus_high.create_fmap_desc %alloc_118 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %169 = zeus_high.create_fmap_desc %alloc_119 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %170 = zeus_high.create_fmap_desc %alloc_120 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_113, %alloc_117 desc(%163, %167) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_114, %alloc_118 desc(%164, %168) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_115, %alloc_119 desc(%165, %169) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_116, %alloc_120 desc(%166, %170) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_113, %alloc_117 desc(%163, %167) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_114, %alloc_118 desc(%164, %168) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_115, %alloc_119 desc(%165, %169) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_116, %alloc_120 desc(%166, %170) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    %subview_121 = memref.subview %alloc_49[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>
    %subview_122 = memref.subview %alloc_57[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    zeus_high.gather %alloc_29, idx %subview_121, out %subview_122, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    memref.dealloc %alloc_49 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_29 : memref<1x1x1x320xf32>
    %subview_123 = memref.subview %alloc_50[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>
    %subview_124 = memref.subview %alloc_60[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    zeus_high.gather %alloc_30, idx %subview_123, out %subview_124, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    memref.dealloc %alloc_50 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_30 : memref<1x1x1x320xf32>
    %subview_125 = memref.subview %alloc_51[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>
    %subview_126 = memref.subview %alloc_63[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    zeus_high.gather %alloc_31, idx %subview_125, out %subview_126, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    memref.dealloc %alloc_51 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_31 : memref<1x1x1x320xf32>
    %subview_127 = memref.subview %alloc_52[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>
    %subview_128 = memref.subview %alloc_66[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    zeus_high.gather %alloc_32, idx %subview_127, out %subview_128, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    memref.dealloc %alloc_52 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_32 : memref<1x1x1x320xf32>
    %alloc_129 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655559961184_lane0, zeus.topk_pair_id = 94655559962608 : i64} : memref<1x1x1x32xi32>
    %alloc_130 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655559961184_lane1, zeus.topk_pair_id = 94655559962608 : i64} : memref<1x1x1x32xi32>
    %alloc_131 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655559961184_lane2, zeus.topk_pair_id = 94655559962608 : i64} : memref<1x1x1x32xi32>
    %alloc_132 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655559961184_lane3, zeus.topk_pair_id = 94655559962608 : i64} : memref<1x1x1x32xi32>
    %171 = zeus_high.create_fmap_desc %alloc_129 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_129 : memref<1x1x1x32xi32>
    %172 = zeus_high.create_fmap_desc %alloc_130 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_130 : memref<1x1x1x32xi32>
    %173 = zeus_high.create_fmap_desc %alloc_131 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_131 : memref<1x1x1x32xi32>
    %174 = zeus_high.create_fmap_desc %alloc_132 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_132 : memref<1x1x1x32xi32>
    %alloc_133 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655559961184_lane0, zeus.topk_pair_id = 94655559962608 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %alloc_134 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655559961184_lane1, zeus.topk_pair_id = 94655559962608 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %alloc_135 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655559961184_lane2, zeus.topk_pair_id = 94655559962608 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %alloc_136 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655559961184_lane3, zeus.topk_pair_id = 94655559962608 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %175 = zeus_high.create_fmap_desc %alloc_133 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    %176 = zeus_high.create_fmap_desc %alloc_134 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    %177 = zeus_high.create_fmap_desc %alloc_135 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    %178 = zeus_high.create_fmap_desc %alloc_136 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_113, %alloc_117 desc(%163, %167) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_114, %alloc_118 desc(%164, %168) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_115, %alloc_119 desc(%165, %169) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_116, %alloc_120 desc(%166, %170) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    %alloc_137 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %179 = zeus_high.create_fmap_desc %alloc_137 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %alloc_138 = memref.alloc() {alignment = 128 : i64, zeus.l2_alias_tag = "topk_stream_4"} : memref<1x1x1x32xf32>
    %180 = zeus_high.create_fmap_desc %alloc_138 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %alloc_139 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_stream_4} : memref<1x1x1x8xi32>
    %181 = zeus_high.create_fmap_desc %alloc_139 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_113, %alloc_138 desc(%163, %180) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = false, tkv = 3 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    %alloc_140 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %182 = zeus_high.create_fmap_desc %alloc_140 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %alloc_141 = memref.alloc() {alignment = 128 : i64, zeus.l2_alias_tag = "topk_stream_5"} : memref<1x1x1x32xf32>
    %183 = zeus_high.create_fmap_desc %alloc_141 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %alloc_142 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_stream_5} : memref<1x1x1x8xi32>
    %184 = zeus_high.create_fmap_desc %alloc_142 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_114, %alloc_141 desc(%164, %183) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = false, tkv = 3 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    %alloc_143 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %185 = zeus_high.create_fmap_desc %alloc_143 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %alloc_144 = memref.alloc() {alignment = 128 : i64, zeus.l2_alias_tag = "topk_stream_6"} : memref<1x1x1x32xf32>
    %186 = zeus_high.create_fmap_desc %alloc_144 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %alloc_145 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_stream_6} : memref<1x1x1x8xi32>
    %187 = zeus_high.create_fmap_desc %alloc_145 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_115, %alloc_144 desc(%165, %186) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = false, tkv = 3 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    %alloc_146 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %188 = zeus_high.create_fmap_desc %alloc_146 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %alloc_147 = memref.alloc() {alignment = 128 : i64, zeus.l2_alias_tag = "topk_stream_7"} : memref<1x1x1x32xf32>
    %189 = zeus_high.create_fmap_desc %alloc_147 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %alloc_148 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_stream_7} : memref<1x1x1x8xi32>
    %190 = zeus_high.create_fmap_desc %alloc_148 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_116, %alloc_147 desc(%166, %189) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = false, tkv = 3 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_113, %alloc_117 desc(%163, %167) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_114, %alloc_118 desc(%164, %168) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_115, %alloc_119 desc(%165, %169) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_116, %alloc_120 desc(%166, %170) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_113, %alloc_117 desc(%163, %167) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_114, %alloc_118 desc(%164, %168) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_115, %alloc_119 desc(%165, %169) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_116, %alloc_120 desc(%166, %170) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_113, %alloc_117 desc(%163, %167) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_114, %alloc_118 desc(%164, %168) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_115, %alloc_119 desc(%165, %169) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_116, %alloc_120 desc(%166, %170) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_113, %alloc_117 desc(%163, %167) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_117 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_113 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_114, %alloc_118 desc(%164, %168) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_118 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_114 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_115, %alloc_119 desc(%165, %169) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_119 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_115 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_116, %alloc_120 desc(%166, %170) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_120 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_116 : memref<1x1x1x320xf32>
    %alloc_149 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %alloc_150 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %alloc_151 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %alloc_152 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %191 = zeus_high.create_fmap_desc %alloc_149 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    %192 = zeus_high.create_fmap_desc %alloc_150 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    %193 = zeus_high.create_fmap_desc %alloc_151 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    %194 = zeus_high.create_fmap_desc %alloc_152 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_57, %alloc_149 desc(%107, %191) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.vp %alloc_60, %alloc_150 desc(%110, %192) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.vp %alloc_63, %alloc_151 desc(%113, %193) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.vp %alloc_66, %alloc_152 desc(%116, %194) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    %subview_153 = memref.subview %alloc_139[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>
    %subview_154 = memref.subview %alloc_137[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    zeus_high.gather %alloc_97, idx %subview_153, out %subview_154, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    memref.dealloc %alloc_139 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_138 : memref<1x1x1x32xf32>
    zeus_high.vp %alloc_149, %alloc_149 desc(%191, %191) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_149 : memref<1x1x1x1xf32>
    zeus_high.vp %alloc_150, %alloc_150 desc(%192, %192) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_150 : memref<1x1x1x1xf32>
    zeus_high.vp %alloc_151, %alloc_151 desc(%193, %193) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_151 : memref<1x1x1x1xf32>
    zeus_high.vp %alloc_152, %alloc_152 desc(%194, %194) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    %subview_155 = memref.subview %alloc_142[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>
    %subview_156 = memref.subview %alloc_140[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    zeus_high.gather %alloc_98, idx %subview_155, out %subview_156, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    memref.dealloc %alloc_142 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_141 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_152 : memref<1x1x1x1xf32>
    %subview_157 = memref.subview %alloc_6[0, 0, 0, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1]>>
    %cast_158 = memref.cast %subview_157 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1]>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %subview_159 = memref.subview %alloc_6[0, 0, 1, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 8>>
    %cast_160 = memref.cast %subview_159 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 8>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %subview_161 = memref.subview %alloc_6[0, 0, 2, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 16>>
    %cast_162 = memref.cast %subview_161 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 16>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %subview_163 = memref.subview %alloc_6[0, 0, 3, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 24>>
    %cast_164 = memref.cast %subview_163 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 24>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %195 = zeus_high.create_fmap_desc %cast_158 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %196 = zeus_high.create_fmap_desc %cast_160 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %197 = zeus_high.create_fmap_desc %cast_162 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %198 = zeus_high.create_fmap_desc %cast_164 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %199 = zeus_high.set_pos %195 [0, 0, %c0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %200 = zeus_high.set_pos %196 [0, 0, %c1, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %201 = zeus_high.set_pos %197 [0, 0, %c2, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %202 = zeus_high.set_pos %198 [0, 0, %c3, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_57, %arg7, %cast_158 desc(%107, %199) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_57 : memref<1x1x1x8xf32>
    zeus_high.vp %alloc_60, %arg7, %cast_160 desc(%110, %200) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_60 : memref<1x1x1x8xf32>
    zeus_high.vp %alloc_63, %arg7, %cast_162 desc(%113, %201) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_63 : memref<1x1x1x8xf32>
    zeus_high.vp %alloc_66, %arg7, %cast_164 desc(%116, %202) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %subview_165 = memref.subview %alloc_145[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>
    %subview_166 = memref.subview %alloc_143[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    zeus_high.gather %alloc_99, idx %subview_165, out %subview_166, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    memref.dealloc %alloc_145 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_144 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_66 : memref<1x1x1x8xf32>
    %subview_167 = memref.subview %alloc_10[0, 0, 0, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1]>>
    %cast_168 = memref.cast %subview_167 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1]>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %subview_169 = memref.subview %alloc_10[0, 0, 1, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 32>>
    %cast_170 = memref.cast %subview_169 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 32>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %subview_171 = memref.subview %alloc_10[0, 0, 2, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 64>>
    %cast_172 = memref.cast %subview_171 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 64>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %subview_173 = memref.subview %alloc_10[0, 0, 3, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 96>>
    %cast_174 = memref.cast %subview_173 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 96>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %203 = zeus_high.create_fmap_desc %cast_168 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %204 = zeus_high.create_fmap_desc %cast_170 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %205 = zeus_high.create_fmap_desc %cast_172 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %206 = zeus_high.create_fmap_desc %cast_174 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %subview_175 = memref.subview %alloc_5[0, 0, 0, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1]>>
    %cast_176 = memref.cast %subview_175 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1]>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %subview_177 = memref.subview %alloc_5[0, 0, 1, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 320>>
    %cast_178 = memref.cast %subview_177 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 320>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %subview_179 = memref.subview %alloc_5[0, 0, 2, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 640>>
    %cast_180 = memref.cast %subview_179 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 640>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %subview_181 = memref.subview %alloc_5[0, 0, 3, 0] [1, 1, 1, 320] [1, 1, 1, 1] : memref<1x1x4x320xbf16> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 960>>
    %cast_182 = memref.cast %subview_181 : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: 960>> to memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>
    %207 = zeus_high.create_fmap_desc %cast_176 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %208 = zeus_high.create_fmap_desc %cast_178 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %209 = zeus_high.create_fmap_desc %cast_180 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %210 = zeus_high.create_fmap_desc %cast_182 {offset = 0, tensor_shape = [1, 1, 4, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>> -> !zeus_high.fmap_desc
    %211 = zeus_high.set_pos %207 [0, 0, %c0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %212 = zeus_high.set_pos %208 [0, 0, %c1, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %213 = zeus_high.set_pos %209 [0, 0, %c2, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %214 = zeus_high.set_pos %210 [0, 0, %c3, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %alloc_183 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_184 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_185 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_186 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %215 = zeus_high.create_fmap_desc %alloc_183 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %216 = zeus_high.create_fmap_desc %alloc_184 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %217 = zeus_high.create_fmap_desc %alloc_185 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %218 = zeus_high.create_fmap_desc %alloc_186 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %cast_176, %alloc_183 desc(%211, %215) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_178, %alloc_184 desc(%212, %216) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_180, %alloc_185 desc(%213, %217) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_182, %alloc_186 desc(%214, %218) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    %subview_187 = memref.subview %alloc_148[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>
    %subview_188 = memref.subview %alloc_146[0, 0, 0, 0] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    zeus_high.gather %alloc_100, idx %subview_187, out %subview_188, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1]>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1]>>
    memref.dealloc %alloc_148 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_147 : memref<1x1x1x32xf32>
    %alloc_189 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_190 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_191 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_192 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %219 = zeus_high.create_fmap_desc %alloc_189 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %220 = zeus_high.create_fmap_desc %alloc_190 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %221 = zeus_high.create_fmap_desc %alloc_191 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %222 = zeus_high.create_fmap_desc %alloc_192 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %cast_176, %alloc_189 desc(%211, %219) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_178, %alloc_190 desc(%212, %220) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_180, %alloc_191 desc(%213, %221) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_182, %alloc_192 desc(%214, %222) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0", mode = "sum_0_x_add_c", scalar_val = 8.000000e+01 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    %alloc_193 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_194 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_195 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_196 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %223 = zeus_high.create_fmap_desc %alloc_193 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %224 = zeus_high.create_fmap_desc %alloc_194 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %225 = zeus_high.create_fmap_desc %alloc_195 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %226 = zeus_high.create_fmap_desc %alloc_196 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_14, %alloc_14 desc(%46, %46) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %alloc_14, %alloc_14 desc(%46, %46) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %alloc_14, %alloc_14 desc(%46, %46) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %alloc_14, %alloc_14 desc(%46, %46) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 1 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x192xf32>, memref<1x1x1x192xf32>
    zeus_high.vp %cast_176, %alloc_193 desc(%211, %223) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_178, %alloc_194 desc(%212, %224) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_180, %alloc_195 desc(%213, %225) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    zeus_high.vp %cast_182, %alloc_196 desc(%214, %226) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "max", mode = "cmp_mat_two_x_c", scalar_val = -1.040000e+02 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xbf16, strided<[1280, 1280, 320, 1], offset: ?>>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_5 : memref<1x1x4x320xbf16>
    memref.dealloc %alloc_14 : memref<1x1x1x192xf32>
    zeus_high.vp %alloc_183, %alloc_183 desc(%215, %215) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_184, %alloc_184 desc(%216, %216) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_185, %alloc_185 desc(%217, %217) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_186, %alloc_186 desc(%218, %218) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = 8.000000e+01 : f32}, {name = "precal", mode = "neg_x"}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 1.000000e+00 : f32, qk = 1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_193, %alloc_193 desc(%223, %223) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_194, %alloc_194 desc(%224, %224) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_195, %alloc_195 desc(%225, %225) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_196, %alloc_196 desc(%226, %226) {op_type = "sigmoid", modules = [{name = "cmt", cmps = "min", mode = "cmp_mat_two_x_c", scalar_val = -8.000000e+01 : f32}, {name = "sum0_l0", mode = "sum_0_l0_x_add_c", scalar_val = 15.9423857 : f32}, {name = "mul_l0", mode = "mul_l0_x_c", scalar_val = 1.44269502 : f32}, {name = "flr_l0", fgdm = 1 : i64, mode = "flr_l0_s_x"}, {name = "sum1_l0", mode = "sum_1_l0_x_minus_s"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 1 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_left"}, {name = "postcal", mode = "qk_x_add_qb", qb = 0.000000e+00 : f32, qk = 1.1920929E-7 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    %alloc_197 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %alloc_198 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %alloc_199 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %alloc_200 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x96xf32>
    %227 = zeus_high.create_fmap_desc %alloc_197 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %228 = zeus_high.create_fmap_desc %alloc_198 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %229 = zeus_high.create_fmap_desc %alloc_199 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %230 = zeus_high.create_fmap_desc %alloc_200 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<1x1x1x96xf32> -> !zeus_high.fmap_desc
    %231 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %232 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %233 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %234 = zeus_high.create_fmap_desc %70 {offset = 0, tensor_shape = [1, 1, 1, 96], tile_shape = [1, 1, 1, 96]} : memref<96xf32> -> !zeus_high.fmap_desc
    %235 = zeus_high.set_pos %231 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %236 = zeus_high.set_pos %232 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %237 = zeus_high.set_pos %233 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %238 = zeus_high.set_pos %234 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %239 = zeus_high.set_pos %227 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %240 = zeus_high.set_pos %228 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %241 = zeus_high.set_pos %229 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %242 = zeus_high.set_pos %230 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.load %70, %alloc_197 desc(%235, %239) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_197, %alloc_197 desc(%227, %227) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    zeus_high.load %70, %alloc_198 desc(%236, %240) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_198, %alloc_198 desc(%228, %228) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    zeus_high.load %70, %alloc_199 desc(%237, %241) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_199, %alloc_199 desc(%229, %229) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    zeus_high.load %70, %alloc_200 desc(%238, %242) : memref<96xf32>, memref<1x1x1x96xf32>
    zeus_high.vp %alloc_200, %alloc_200 desc(%230, %230) {op_type = "sigmoid", modules = [{name = "prg_l1", mode = "prg_l1_load", segn = 0 : i64}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x96xf32>, memref<1x1x1x96xf32>
    memref.dealloc %alloc_197 : memref<1x1x1x96xf32>
    memref.dealloc %alloc_198 : memref<1x1x1x96xf32>
    memref.dealloc %alloc_199 : memref<1x1x1x96xf32>
    memref.dealloc %alloc_200 : memref<1x1x1x96xf32>
    %alloc_201 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_202 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_203 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_204 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %243 = zeus_high.create_fmap_desc %alloc_201 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %244 = zeus_high.create_fmap_desc %alloc_202 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %245 = zeus_high.create_fmap_desc %alloc_203 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %246 = zeus_high.create_fmap_desc %alloc_204 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_183, %alloc_201 desc(%215, %243) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_184, %alloc_202 desc(%216, %244) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_185, %alloc_203 desc(%217, %245) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_186, %alloc_204 desc(%218, %246) {op_type = "sigmoid", modules = [{name = "dip_l0", mode = "dip_l0_e_m"}, {name = "prg_l1", cgfs = 0 : i64, mode = "prg_l1_x", segn = 0 : i64}, {name = "mul_l1", mode = "mul_l1_x_k"}, {name = "sum1_l1", mode = "sum_1_l1_x_add_b"}, {name = "shf_l1", mode = "shf_l1_x_s_right"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_183, %alloc_201, %alloc_183 desc(%215, %243, %215) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_184, %alloc_202, %alloc_184 desc(%216, %244, %216) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_185, %alloc_203, %alloc_185 desc(%217, %245, %217) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_186, %alloc_204, %alloc_186 desc(%218, %246, %218) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}, {name = "postcal", mode = "qk_x_add_qb", qb = 2.000000e+00 : f32, qk = -1.000000e+00 : f32}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_201, %alloc_183, %alloc_201 desc(%243, %215, %243) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_183 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_202, %alloc_184, %alloc_202 desc(%244, %216, %244) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_184 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_203, %alloc_185, %alloc_203 desc(%245, %217, %245) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_185 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_204, %alloc_186, %alloc_204 desc(%246, %218, %246) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_186 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_193, %alloc_189, %alloc_193 desc(%223, %219, %223) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_194, %alloc_190, %alloc_194 desc(%224, %220, %224) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_195, %alloc_191, %alloc_195 desc(%225, %221, %225) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_196, %alloc_192, %alloc_196 desc(%226, %222, %226) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_a_0"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_201, %alloc_189, %alloc_201 desc(%243, %219, %243) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_189 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_202, %alloc_190, %alloc_202 desc(%244, %220, %244) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_190 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_203, %alloc_191, %alloc_203 desc(%245, %221, %245) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_191 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_204, %alloc_192, %alloc_204 desc(%246, %222, %246) {op_type = "sigmoid", modules = [{name = "mul", mode = "mul_x_y_where_0_b"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_192 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_193, %alloc_201, %alloc_193 desc(%223, %243, %223) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_201 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_194, %alloc_202, %alloc_194 desc(%224, %244, %224) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_202 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_195, %alloc_203, %alloc_195 desc(%225, %245, %225) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_203 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_196, %alloc_204, %alloc_196 desc(%226, %246, %226) {op_type = "sigmoid", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc_204 : memref<1x1x1x320xf32>
    %alloc_205 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_206 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_207 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %alloc_208 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x320xf32>
    %247 = zeus_high.create_fmap_desc %alloc_205 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %248 = zeus_high.create_fmap_desc %alloc_206 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %249 = zeus_high.create_fmap_desc %alloc_207 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    %250 = zeus_high.create_fmap_desc %alloc_208 {offset = 0, tensor_shape = [1, 1, 1, 320], tile_shape = [1, 1, 1, 320]} : memref<1x1x1x320xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_193, %alloc, %alloc_205 desc(%223, %5, %247) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_194, %alloc, %alloc_206 desc(%224, %5, %248) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_195, %alloc, %alloc_207 desc(%225, %5, %249) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    zeus_high.vp %alloc_196, %alloc, %alloc_208 desc(%226, %5, %250) {op_type = "add", modules = [{name = "sum0", mode = "sum_0_x_add_y"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x320xf32>, memref<1x1x1x320xf32>
    memref.dealloc %alloc : memref<1x1x1x320xf32>
    %alloc_209 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_packet_destination_2, zeus.l2_alias_tag = "topk_vp_result_94655560041968_lane0"} : memref<1x1x1x32xf32>
    %alloc_210 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 128 : i64, zeus.l2_alias_of = @topk_packet_destination_2, zeus.l2_alias_tag = "topk_vp_result_94655560041968_lane1"} : memref<1x1x1x32xf32>
    %alloc_211 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 256 : i64, zeus.l2_alias_of = @topk_packet_destination_2, zeus.l2_alias_tag = "topk_vp_result_94655560041968_lane2"} : memref<1x1x1x32xf32>
    %alloc_212 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 384 : i64, zeus.l2_alias_of = @topk_packet_destination_2, zeus.l2_alias_tag = "topk_vp_result_94655560041968_lane3"} : memref<1x1x1x32xf32>
    %251 = zeus_high.create_fmap_desc %alloc_209 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %252 = zeus_high.create_fmap_desc %alloc_210 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %253 = zeus_high.create_fmap_desc %alloc_211 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    %254 = zeus_high.create_fmap_desc %alloc_212 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_205, %alloc_209 desc(%247, %251) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_206, %alloc_210 desc(%248, %252) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_207, %alloc_211 desc(%249, %253) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_208, %alloc_212 desc(%250, %254) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 0 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 0 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_205, %alloc_209 desc(%247, %251) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_206, %alloc_210 desc(%248, %252) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_207, %alloc_211 desc(%249, %253) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_208, %alloc_212 desc(%250, %254) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 1 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 1 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    %subview_213 = memref.subview %alloc_133[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>
    %subview_214 = memref.subview %alloc_137[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    zeus_high.gather %alloc_97, idx %subview_213, out %subview_214, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    memref.dealloc %alloc_133 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_97 : memref<1x1x1x320xf32>
    %subview_215 = memref.subview %alloc_134[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>
    %subview_216 = memref.subview %alloc_140[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    zeus_high.gather %alloc_98, idx %subview_215, out %subview_216, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    memref.dealloc %alloc_134 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_98 : memref<1x1x1x320xf32>
    %subview_217 = memref.subview %alloc_135[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>
    %subview_218 = memref.subview %alloc_143[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    zeus_high.gather %alloc_99, idx %subview_217, out %subview_218, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    memref.dealloc %alloc_135 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_99 : memref<1x1x1x320xf32>
    %subview_219 = memref.subview %alloc_136[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xi32> to memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>
    %subview_220 = memref.subview %alloc_146[0, 0, 0, 4] [1, 1, 1, 4] [1, 1, 1, 1] : memref<1x1x1x8xf32> to memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    zeus_high.gather %alloc_100, idx %subview_219, out %subview_220, k 4 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x4xi32, strided<[8, 8, 8, 1], offset: 4>>, memref<1x1x1x4xf32, strided<[8, 8, 8, 1], offset: 4>>
    memref.dealloc %alloc_136 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_100 : memref<1x1x1x320xf32>
    %alloc_221 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655560041968_lane0, zeus.topk_pair_id = 94655560025408 : i64} : memref<1x1x1x32xi32>
    %alloc_222 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655560041968_lane1, zeus.topk_pair_id = 94655560025408 : i64} : memref<1x1x1x32xi32>
    %alloc_223 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655560041968_lane2, zeus.topk_pair_id = 94655560025408 : i64} : memref<1x1x1x32xi32>
    %alloc_224 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 0 : i64, zeus.l2_alias_of = @topk_vp_result_94655560041968_lane3, zeus.topk_pair_id = 94655560025408 : i64} : memref<1x1x1x32xi32>
    %255 = zeus_high.create_fmap_desc %alloc_221 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_221 : memref<1x1x1x32xi32>
    %256 = zeus_high.create_fmap_desc %alloc_222 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_222 : memref<1x1x1x32xi32>
    %257 = zeus_high.create_fmap_desc %alloc_223 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_223 : memref<1x1x1x32xi32>
    %258 = zeus_high.create_fmap_desc %alloc_224 {offset = 0, tensor_shape = [1, 1, 1, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32> -> !zeus_high.fmap_desc
    memref.dealloc %alloc_224 : memref<1x1x1x32xi32>
    %alloc_225 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655560041968_lane0, zeus.topk_pair_id = 94655560025408 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %alloc_226 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655560041968_lane1, zeus.topk_pair_id = 94655560025408 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %alloc_227 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655560041968_lane2, zeus.topk_pair_id = 94655560025408 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %alloc_228 = memref.alloc() {alignment = 16 : i64, zeus.l2_alias_byte_offset = 64 : i64, zeus.l2_alias_of = @topk_vp_result_94655560041968_lane3, zeus.topk_pair_id = 94655560025408 : i64, zeus.topk_role = "indices"} : memref<1x1x1x8xi32>
    %259 = zeus_high.create_fmap_desc %alloc_225 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    %260 = zeus_high.create_fmap_desc %alloc_226 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    %261 = zeus_high.create_fmap_desc %alloc_227 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    %262 = zeus_high.create_fmap_desc %alloc_228 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xi32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_205, %alloc_209 desc(%247, %251) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_206, %alloc_210 desc(%248, %252) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_207, %alloc_211 desc(%249, %253) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_208, %alloc_212 desc(%250, %254) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 2 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 2 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_205, %alloc_209 desc(%247, %251) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 3 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_206, %alloc_210 desc(%248, %252) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 3 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_207, %alloc_211 desc(%249, %253) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 3 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_208, %alloc_212 desc(%250, %254) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 3 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 3 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_205, %alloc_209 desc(%247, %251) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_206, %alloc_210 desc(%248, %252) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_207, %alloc_211 desc(%249, %253) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_208, %alloc_212 desc(%250, %254) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 4 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 4 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_205, %alloc_209 desc(%247, %251) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_206, %alloc_210 desc(%248, %252) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_207, %alloc_211 desc(%249, %253) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_208, %alloc_212 desc(%250, %254) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 5 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 5 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_205, %alloc_209 desc(%247, %251) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_206, %alloc_210 desc(%248, %252) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_207, %alloc_211 desc(%249, %253) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_208, %alloc_212 desc(%250, %254) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk", mskrc = false, tkv = 6 : i64, tkvo = false, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 6 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    zeus_high.vp %alloc_205, %alloc_209 desc(%247, %251) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_209 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_205 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_206, %alloc_210 desc(%248, %252) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_210 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_206 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_207, %alloc_211 desc(%249, %253) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_211 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_207 : memref<1x1x1x320xf32>
    zeus_high.vp %alloc_208, %alloc_212 desc(%250, %254) {op_type = "topk_step", modules = [{name = "msk", cmps = 1 : i64, mode = "cmp_mat_tree_c_w_h_msk_out", mskrc = true, tkv = 7 : i64, tkvo = true, topk = 8 : i64}], tensor_mode = 1 : i64, topk_k = 8 : i64, topk_step_index = 7 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x32xf32>
    memref.dealloc %alloc_212 : memref<1x1x1x32xf32>
    memref.dealloc %alloc_208 : memref<1x1x1x320xf32>
    %alloc_229 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %alloc_230 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %alloc_231 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %alloc_232 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %263 = zeus_high.create_fmap_desc %alloc_229 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    %264 = zeus_high.create_fmap_desc %alloc_230 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    %265 = zeus_high.create_fmap_desc %alloc_231 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    %266 = zeus_high.create_fmap_desc %alloc_232 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_137, %alloc_229 desc(%179, %263) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.vp %alloc_140, %alloc_230 desc(%182, %264) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.vp %alloc_143, %alloc_231 desc(%185, %265) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.vp %alloc_146, %alloc_232 desc(%188, %266) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.vp %alloc_229, %alloc_229 desc(%263, %263) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_229 : memref<1x1x1x1xf32>
    zeus_high.vp %alloc_230, %alloc_230 desc(%264, %264) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_230 : memref<1x1x1x1xf32>
    zeus_high.vp %alloc_231, %alloc_231 desc(%265, %265) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_231 : memref<1x1x1x1xf32>
    zeus_high.vp %alloc_232, %alloc_232 desc(%266, %266) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_232 : memref<1x1x1x1xf32>
    %subview_233 = memref.subview %alloc_7[0, 0, 0, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1]>>
    %cast_234 = memref.cast %subview_233 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1]>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %subview_235 = memref.subview %alloc_7[0, 0, 1, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 8>>
    %cast_236 = memref.cast %subview_235 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 8>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %subview_237 = memref.subview %alloc_7[0, 0, 2, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 16>>
    %cast_238 = memref.cast %subview_237 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 16>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %subview_239 = memref.subview %alloc_7[0, 0, 3, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 24>>
    %cast_240 = memref.cast %subview_239 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 24>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %267 = zeus_high.create_fmap_desc %cast_234 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %268 = zeus_high.create_fmap_desc %cast_236 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %269 = zeus_high.create_fmap_desc %cast_238 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %270 = zeus_high.create_fmap_desc %cast_240 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %271 = zeus_high.set_pos %267 [0, 0, %c0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %272 = zeus_high.set_pos %268 [0, 0, %c1, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %273 = zeus_high.set_pos %269 [0, 0, %c2, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %274 = zeus_high.set_pos %270 [0, 0, %c3, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_137, %arg7, %cast_234 desc(%179, %271) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_137 : memref<1x1x1x8xf32>
    zeus_high.vp %alloc_140, %arg7, %cast_236 desc(%182, %272) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_140 : memref<1x1x1x8xf32>
    zeus_high.vp %alloc_143, %arg7, %cast_238 desc(%185, %273) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_143 : memref<1x1x1x8xf32>
    zeus_high.vp %alloc_146, %arg7, %cast_240 desc(%188, %274) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_146 : memref<1x1x1x8xf32>
    %subview_241 = memref.subview %alloc_11[0, 0, 0, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1]>>
    %cast_242 = memref.cast %subview_241 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1]>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %subview_243 = memref.subview %alloc_11[0, 0, 1, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 32>>
    %cast_244 = memref.cast %subview_243 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 32>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %subview_245 = memref.subview %alloc_11[0, 0, 2, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 64>>
    %cast_246 = memref.cast %subview_245 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 64>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %subview_247 = memref.subview %alloc_11[0, 0, 3, 0] [1, 1, 1, 32] [1, 1, 1, 1] : memref<1x1x4x32xi32> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 96>>
    %cast_248 = memref.cast %subview_247 : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: 96>> to memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>>
    %275 = zeus_high.create_fmap_desc %cast_242 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %276 = zeus_high.create_fmap_desc %cast_244 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %277 = zeus_high.create_fmap_desc %cast_246 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %278 = zeus_high.create_fmap_desc %cast_248 {offset = 0, tensor_shape = [1, 1, 4, 32], tile_shape = [1, 1, 1, 32]} : memref<1x1x1x32xi32, strided<[128, 128, 32, 1], offset: ?>> -> !zeus_high.fmap_desc
    %alloc_249 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %alloc_250 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %alloc_251 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %alloc_252 = memref.alloc() {alignment = 128 : i64} : memref<1x1x1x8xf32>
    %279 = zeus_high.create_fmap_desc %alloc_249 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %280 = zeus_high.create_fmap_desc %alloc_250 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %281 = zeus_high.create_fmap_desc %alloc_251 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    %282 = zeus_high.create_fmap_desc %alloc_252 {offset = 0, tensor_shape = [1, 1, 1, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xf32> -> !zeus_high.fmap_desc
    zeus_high.gather %alloc_193, idx %alloc_225, out %alloc_249, k 8 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x8xi32>, memref<1x1x1x8xf32>
    memref.dealloc %alloc_225 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_193 : memref<1x1x1x320xf32>
    %alloc_253 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %283 = zeus_high.create_fmap_desc %alloc_253 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_249, %alloc_253 desc(%279, %283) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 0 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.gather %alloc_194, idx %alloc_226, out %alloc_250, k 8 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x8xi32>, memref<1x1x1x8xf32>
    memref.dealloc %alloc_226 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_194 : memref<1x1x1x320xf32>
    %alloc_254 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %284 = zeus_high.create_fmap_desc %alloc_254 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_250, %alloc_254 desc(%280, %284) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 1 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.gather %alloc_195, idx %alloc_227, out %alloc_251, k 8 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x8xi32>, memref<1x1x1x8xf32>
    memref.dealloc %alloc_227 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_195 : memref<1x1x1x320xf32>
    %alloc_255 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %285 = zeus_high.create_fmap_desc %alloc_255 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_251, %alloc_255 desc(%281, %285) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 2 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.gather %alloc_196, idx %alloc_228, out %alloc_252, k 8 {index_lower_bound = 0 : i64, index_upper_bound = 320 : i64} : memref<1x1x1x320xf32>, memref<1x1x1x8xi32>, memref<1x1x1x8xf32>
    memref.dealloc %alloc_228 : memref<1x1x1x8xi32>
    memref.dealloc %alloc_196 : memref<1x1x1x320xf32>
    %alloc_256 = memref.alloc() {alignment = 16 : i64} : memref<1x1x1x1xf32>
    %286 = zeus_high.create_fmap_desc %alloc_256 {offset = 0, tensor_shape = [1, 1, 1, 1], tile_shape = [1, 1, 1, 1]} : memref<1x1x1x1xf32> -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_252, %alloc_256 desc(%282, %286) {op_type = "rsqrt", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "sqr", scsq = 1 : i64}], tensor_mode = 1 : i64, zeus.parallel_executor_lane = 3 : i64} : memref<1x1x1x8xf32>, memref<1x1x1x1xf32>
    zeus_high.vp %alloc_253, %alloc_253 desc(%283, %283) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_253 : memref<1x1x1x1xf32>
    zeus_high.vp %alloc_254, %alloc_254 desc(%284, %284) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_254 : memref<1x1x1x1xf32>
    zeus_high.vp %alloc_255, %alloc_255 desc(%285, %285) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_255 : memref<1x1x1x1xf32>
    zeus_high.vp %alloc_256, %alloc_256 desc(%286, %286) {op_type = "mul", modules = [{name = "smt", mode = "sum_mat_tree_c"}, {name = "mul_sc", mode = "mul_sc_x_x"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64, zeus.vp_feedback_write = "group_mul"} : memref<1x1x1x1xf32>, memref<1x1x1x1xf32>
    memref.dealloc %alloc_256 : memref<1x1x1x1xf32>
    %subview_257 = memref.subview %alloc_8[0, 0, 0, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1]>>
    %cast_258 = memref.cast %subview_257 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1]>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %subview_259 = memref.subview %alloc_8[0, 0, 1, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 8>>
    %cast_260 = memref.cast %subview_259 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 8>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %subview_261 = memref.subview %alloc_8[0, 0, 2, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 16>>
    %cast_262 = memref.cast %subview_261 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 16>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %subview_263 = memref.subview %alloc_8[0, 0, 3, 0] [1, 1, 1, 8] [1, 1, 1, 1] : memref<1x1x4x8xbf16> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 24>>
    %cast_264 = memref.cast %subview_263 : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: 24>> to memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    %287 = zeus_high.create_fmap_desc %cast_258 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %288 = zeus_high.create_fmap_desc %cast_260 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %289 = zeus_high.create_fmap_desc %cast_262 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %290 = zeus_high.create_fmap_desc %cast_264 {offset = 0, tensor_shape = [1, 1, 4, 8], tile_shape = [1, 1, 1, 8]} : memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>> -> !zeus_high.fmap_desc
    %291 = zeus_high.set_pos %287 [0, 0, %c0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %292 = zeus_high.set_pos %288 [0, 0, %c1, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %293 = zeus_high.set_pos %289 [0, 0, %c2, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %294 = zeus_high.set_pos %290 [0, 0, %c3, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.vp %alloc_249, %arg7, %cast_258 desc(%279, %291) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 0 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_249 : memref<1x1x1x8xf32>
    zeus_high.vp %alloc_250, %arg7, %cast_260 desc(%280, %292) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 1 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_250 : memref<1x1x1x8xf32>
    zeus_high.vp %alloc_251, %arg7, %cast_262 desc(%281, %293) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 2 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_251 : memref<1x1x1x8xf32>
    zeus_high.vp %alloc_252, %arg7, %cast_264 desc(%282, %294) {op_type = "mul", modules = [{name = "mul", mode = "mul_x_r"}, {name = "postcal", mode = "mul_runtime_scalar"}], tensor_mode = 0 : i64, zeus.parallel_executor_lane = 3 : i64, zeus.truncf_output = unit, zeus.vp_feedback_read = "group_mul", zeus.vp_feedback_write = "none"} : memref<1x1x1x8xf32>, f32, memref<1x1x1x8xbf16, strided<[32, 32, 8, 1], offset: ?>>
    memref.dealloc %alloc_252 : memref<1x1x1x8xf32>
    %295 = arith.muli %arg12, %c32_i32 : i32
    %296 = arith.index_cast %295 : i32 to index
    %297 = zeus_high.create_fmap_desc %arg4 {offset = 0, tensor_shape = [1, 1, %c4, %c8], tile_shape = [1, 1, 4, 8], dynamic_byte_offset = %296} : memref<*xi32> -> !zeus_high.fmap_desc
    %298 = zeus_high.update_tile %297 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %299 = zeus_high.set_pos %298 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %300 = zeus_high.update_tile %34 [1, 1, 4, 8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %301 = zeus_high.update_tile %300 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %302 = zeus_high.set_pos %301 [0, 0, 0, 16] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.store %alloc_9, %arg4 desc(%302, %299) : memref<1x1x4x32xi32>, memref<*xi32>
    memref.dealloc %alloc_9 : memref<1x1x4x32xi32>
    %303 = arith.muli %8, %c8_i32 : i32
    %304 = arith.index_cast %303 : i32 to index
    %305 = zeus_high.create_fmap_desc %arg4 {offset = 0, tensor_shape = [1, 1, %c4, %c8], tile_shape = [1, 1, 4, 8], dynamic_byte_offset = %304} : memref<*xi32> -> !zeus_high.fmap_desc
    %306 = zeus_high.update_tile %305 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %307 = zeus_high.set_pos %306 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %308 = zeus_high.update_tile %35 [1, 1, 4, 8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %309 = zeus_high.update_tile %308 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %310 = zeus_high.set_pos %309 [0, 0, 0, 16] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.store %alloc_10, %arg4 desc(%310, %307) : memref<1x1x4x32xi32>, memref<*xi32>
    memref.dealloc %alloc_10 : memref<1x1x4x32xi32>
    %311 = arith.muli %10, %c8_i32 : i32
    %312 = arith.index_cast %311 : i32 to index
    %313 = zeus_high.create_fmap_desc %arg4 {offset = 0, tensor_shape = [1, 1, %c4, %c8], tile_shape = [1, 1, 4, 8], dynamic_byte_offset = %312} : memref<*xi32> -> !zeus_high.fmap_desc
    %314 = zeus_high.update_tile %313 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %315 = zeus_high.set_pos %314 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %316 = zeus_high.update_tile %36 [1, 1, 4, 8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %317 = zeus_high.update_tile %316 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %318 = zeus_high.set_pos %317 [0, 0, 0, 16] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.store %alloc_11, %arg4 desc(%318, %315) : memref<1x1x4x32xi32>, memref<*xi32>
    memref.dealloc %alloc_11 : memref<1x1x4x32xi32>
    %319 = zeus_high.create_fmap_desc %arg3 {offset = 0, tensor_shape = [1, 1, %c4, %c8], tile_shape = [1, 1, 4, 8], dynamic_byte_offset = %296} : memref<*xbf16> -> !zeus_high.fmap_desc
    %320 = zeus_high.update_tile %319 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %321 = zeus_high.set_pos %320 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %322 = zeus_high.update_tile %31 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %323 = zeus_high.set_pos %322 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.store %alloc_6, %arg3 desc(%323, %321) : memref<1x1x4x8xbf16>, memref<*xbf16>
    memref.dealloc %alloc_6 : memref<1x1x4x8xbf16>
    %324 = zeus_high.create_fmap_desc %arg3 {offset = 0, tensor_shape = [1, 1, %c4, %c8], tile_shape = [1, 1, 4, 8], dynamic_byte_offset = %304} : memref<*xbf16> -> !zeus_high.fmap_desc
    %325 = zeus_high.update_tile %324 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %326 = zeus_high.set_pos %325 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %327 = zeus_high.update_tile %32 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %328 = zeus_high.set_pos %327 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.store %alloc_7, %arg3 desc(%328, %326) : memref<1x1x4x8xbf16>, memref<*xbf16>
    memref.dealloc %alloc_7 : memref<1x1x4x8xbf16>
    %329 = zeus_high.create_fmap_desc %arg3 {offset = 0, tensor_shape = [1, 1, %c4, %c8], tile_shape = [1, 1, 4, 8], dynamic_byte_offset = %312} : memref<*xbf16> -> !zeus_high.fmap_desc
    %330 = zeus_high.update_tile %329 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %331 = zeus_high.set_pos %330 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %332 = zeus_high.update_tile %33 [1, 1, %c4, %c8] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    %333 = zeus_high.set_pos %332 [0, 0, 0, 0] : !zeus_high.fmap_desc -> !zeus_high.fmap_desc
    zeus_high.store %alloc_8, %arg3 desc(%333, %331) : memref<1x1x4x8xbf16>, memref<*xbf16>
    memref.dealloc %alloc_8 : memref<1x1x4x8xbf16>
    return
  }
}
