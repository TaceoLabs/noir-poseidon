use dep::hash_utils;
use dep::hash_utils::poseidon;

use crate::bn254::consts;

pub(crate) fn x5_2(input: [Field; 2]) -> [Field; 2] {
    permute(input, consts::round_constants_2, poseidon::mds_2)
}

pub(crate) fn x5_3(input: [Field; 3]) -> [Field; 3] {
    permute(input, consts::round_constants_3, mds_3)
}

pub(crate) fn x5_4(input: [Field; 4]) -> [Field; 4] {
    permute(input, consts::round_constants_4, poseidon::mds_4)
}

pub(crate) fn permute<T, R>(mut state: [Field; T], rc: [[Field; T]; R], mds: fn([Field; T]) -> [Field; T]) -> [Field; T] {
    for r in 0..4 {
        state =hash_utils::vec_add(state, rc[r]);
        state =poseidon::sbox(state);
        state = mds(state);
    }
    for r in 4..R - 4 {
        state = hash_utils::vec_add(state, rc[r]);
        state[0] = poseidon::sbox_e(state[0]);
        state = mds(state);
    }
    for r in R - 4..R {
        state =hash_utils::vec_add(state, rc[r]);
        state =poseidon::sbox(state);
        state = mds(state);
    }
    state
}

fn mds_3(state: [Field; 3]) -> [Field; 3] {
    let sum = state.reduce(|a,b| a + b);
    let mut ret_val = [0; 3];
    ret_val[0] = state[0] + sum;
    ret_val[1] = 2 * state[1] + sum;
    ret_val[2] = state[2] + sum;
    ret_val
}

#[test]
fn test_perm_2() {
    assert(
        x5_2(
        [
        0x2ba4370c837e16ac3ff93cb9232e9b784d606af28d1d7d6755dcd74b7d3b78b0,
        0x28c8d2eea9a7ea812170ee4995ebfeb6a0b7533c4a58166ac478d4a5fed2a78d
    ]
    )
        == [
            0x099ec3f2d58ae28da48a059ea2f6d204f565447651b4bdedc4d8d78ae1426052,
            0x043f0c0ccb49e5d08d12cb0b4f5b6a12b33db7404eb3f4c3a2f352fb6eaf78b3
        ]
    );
    assert(
        x5_2(
        [
        0x2a571de73e8592d3897ebcb49161b2f329fb8e423c4301c7a4927116bb445595,
        0x2f1fd71cbcbdb52445a271b842241497c150c31cb2998d5d62904384a402783c
    ]
    )
        == [
            0x1939a3370bc4a4d85eeb6e46369448e89a6ae5495624506b7e8dcfc2e09283ad,
            0x28abc45a511e31018897d6c7642951f927a73a3e322f0b7ca6060a7e10ed45c2
        ]
    );
    assert(
        x5_2(
        [
        0x2b71b48f39b7734b07e3d9615bff4f3fca0e64a6a92e12359f75761de286eaf1,
        0x094010870b1f40b8d13e6a7abd4da78a4dcde1eb7d80bc9a43c28cc628992ed2
    ]
    )
        == [
            0x15da0cb5d103b833804b72582f330fcd755535c118eafb99d7561a891658d08d,
            0x1bed6daa76d50e20ce4ec32a1e69db1504f01e65616ed375626f8d2e3b02bcd5
        ]
    );
    assert(
        x5_2(
        [
        0x10820a21543bedf7aaf37963e7fce2209a364cf8e29a4a6dd647a2c45aa5e1ef,
        0x079587df8eec17a8cd61cdfb91a5d0445611b224b9b40123b524255c0c6ef1ac
    ]
    )
        == [
            0x1c783dc57dc528526bc9ee3295136e81b2c14ae1ec08c56170efe6dca887fa1e,
            0x0b4e0eaa36d9b8bae29dcfbfda894dd444b9c8010d38d37d3551e95ce30c4ea7
        ]
    );
    assert(
        x5_2(
        [
        0x0e84052864d20e26d5da34273d300f7205411dbe02a697c13119d874840e0f3f,
        0x04751d0b31319b5ab7660b6b67d363678078b2eced5d47617261ec92e22bc74a
    ]
    )
        == [
            0x0a6b9f1bf156fea3c1dfb1463e6b2e9335b10a651620452b1b603b68c53b722f,
            0x2128ee20ec6b5e6642028a8ed6f5d9c5ce01618e438c1f498fe18dc932ad83d3
        ]
    );
    assert(
        x5_2(
        [
        0x011115dc5ec29709bc331d43071614ee3374a66d0849d241290a9a5904f177cc,
        0x15f16434a98672548fd9acca7b8fc06b894edd0288e0feb7728a9680088ff948
    ]
    )
        == [
            0x27a24de9196695b69439f2dd3ff5e1dc0af7c12df04cf6a79b194996d43feec2,
            0x21ecd38de1bb939cb286e92f9e5207021638bff4b9f0db322af1d6eda4a47213
        ]
    );
    assert(
        x5_2(
        [
        0x2bfc4ff78ffc4a650d9a4443162602ccfa1f0f7b3995ed9711a792ff44543544,
        0x0d88e6355f118246e5fece9c58fc631e0a910441567f4d7daf8002697d4ed7df
    ]
    )
        == [
            0x301a1cdd5c8b4696a6e3f7b15063a6fded574b17bf44ccd22c6c6849b7ab4eff,
            0x20c82986df4a1434bd472e823e4fd6adc5d56017c26483a9e4d722abc57aabc7
        ]
    );
    assert(
        x5_2(
        [
        0x1d4b737cba018f04dfa77a0cf0c3f15fcc98c0a684f405c544e07e3e0e72f6c1,
        0x11b07673a7b06b07f06c8c9267e826a2ce57644cf746f094e3e7b434612be51b
    ]
    )
        == [
            0x0d7eca30b61d349cd68e1643cc55fedf20d08dd7f06a3001e12c279748984223,
            0x0e12a4061406ff162ce63f23df66a9f75c865c3eca8d5c106b6c25c5a5b5c0e8
        ]
    );
    assert(
        x5_2(
        [
        0x27dc3876826a964d477a70dc49cc7c72c0118a6118f3da8a9bb5311183de3f33,
        0x1e19ed650053e86d74a9a082e00f63a31cac1ff828d0816b1758b4983aaf7a3b
    ]
    )
        == [
            0x2f65b79da6b825c3a8b3de3dda0691f26bd740b56028e5b84c851952e6d0c7dd,
            0x233b8be458ddd8716a5ef191708af30a7b5536b0c7f2992c8b3d2281710f98a9
        ]
    );
    assert(
        x5_2(
        [
        0x2e316807918bb06843f31b4bb16e9474aafe0bc94fac2b47e2596d4b2c7cbf58,
        0x11d70ff40496648ed95556aef09f88225e62ba430eaa8d0b47443830989d54f3
    ]
    )
        == [
            0x292bbf2451ed79d72d6fbf99e76e65bf45b107277e45162b5c400a4cf13c6eb0,
            0x10c47ea7b6af744feeb5bc6a6de6a63edccbecc8e99a36f36f4a61d01f0944e0
        ]
    );
}

#[test]
fn test_perm_4() {
    assert(
        x5_4([0, 1, 2, 3]) == [
            0x031619039dafde797c63db1777a4e21f8e876a899a15719b8f035ebb30135fbb,
            0x00fa0c6f20e8d75302ddc74ff200993a76529537089cae07e03c8f5cf44097af,
            0x29b48c14d5bf0604ba395924d9cc4eb0d06f255c40adaa2a58aec3e9340d5200,
            0x2d2e925b3778f417eac2683b9a4feef9466ad9fb1bb64d002e5b111d69e62cc6
        ]
    );

    assert(
        x5_4(
        [
        0x23da896d18d0dcef71c233624fd2ba899bc93a60fada8ce32dbb679be380b3c7,
        0x20caddbc1c37a6f6e49b2cc69ef153001ecd70c638b6cb670904666e61a1d8bd,
        0x28a03dc15def5fcaf5fbab14f6c7a02f3589d8a7597aff55e16d7558b6375323,
        0x15b83de819a22b62a558459184bc751a9e47bf34a77419e9201dcb08d04be065
    ]
    )
        == [
            0x06c26cdd6b2a4855f5efdc88b8ec314cfd04b7002afbf5b8bd10ea9ea0a13e65,
            0x195c4f610854362c713e0bae568e4de6b4e7fede4ed9341d3f77b3adaaf6a062,
            0x2d9463208d14861efb15b3be7f8e2d84d396707d849520705f28005eaeda6a67,
            0x2a42ccca1355ec29384d17b9b4ef8f672feca71e10fa8f61d26197844ea92ea5
        ]
    );
    assert(
        x5_4(
        [
        0x0d5eb8c5c46d88254df6b678230ab2a22c7d2166bc91235ee5171797874e8499,
        0x2d9fc8ae6c2a59ea8ea63c8af5f9d8ff0ae469e4b2d8dc944255f308a3bec86f,
        0x1a8667d54e9ef18a85371b48206f402aeb6bcf72ca6b33ea0763b9e891445cf8,
        0x235e694d96384b0c741080c9387828f7c3ff0a9d517aaf5a449d9c2010d033dd
    ]
    )
        == [
            0x246ff511bf51416ebbf6f7791674f877baa275a58d131feb53b547381283e1ba,
            0x0b46b6b70b0f65364a0b50b7a14fb4861cbc0c65f19778fbcd019e01557bc52e,
            0x038be1bf36789070dfe67c44ccd8010aca0efa4cd66ebfcdc3c4736cf5338822,
            0x014af2b562f1aedcad68248026bb875ad38105d10e7afee71652bc1c14273dec
        ]
    );
    assert(
        x5_4(
        [
        0x0114ea1a901772d6b19024000d2a0e10a70652239a81197f8b9218115eeb3dfe,
        0x232d9b783ec19a8418b56748ccaa2c1b3b6c0fb72f21cdd5a5b2464435e39c01,
        0x2b3e8aa14ff2c6f38ae86a1ee293b9fd38ac018951d003891c877ddcb75347ab,
        0x092f1a801ceab8f881a1401f417134bc35fee471b5767c590c3dfcaaf940deca
    ]
    )
        == [
            0x1e331bbaae40425c890ff48d9e4f701b5aac06fa487643d6f3afd344fc378b37,
            0x068cd5c4fc04ca3d7e17bdc3e501f92cf343b95ff60b4d6ae785c0e0b2165b5e,
            0x0f2c4cf8eadb6c878c12c8bacf9d514f092f56171adcc0cc408301873de3134f,
            0x22ca34a95b92a3240b98d192ef72ceeb906800e92ae04038d93d946d2bcf198d
        ]
    );
    assert(
        x5_4(
        [
        0x25a67cb2784a908949549e42faaab75a14748b196e55a772b041c970e32826d9,
        0x1c80695201668c5f058a043046608d6e13905dd704fbc17f40b235e61f398c03,
        0x0b53170e7f3cb756032c361deddab12d4ac70640efbd80fbe3717c9a7ec44e87,
        0x2991ee38d9e0f9596aa2f75743ed5e2d4cd2411fd0b71b2211b729c322d12835
    ]
    )
        == [
            0x1a966845b5276de7f9b8ffb0994c4c8afc3f410ec34275f18fda461117cfc6ea,
            0x3004a134b316c77106745c313d4c76ab7aaa6952572b3624975d9d395d9115f2,
            0x2b9240868de7a94de11da3d80d2065cebb0d65b7bbe8fa083b0b69281f2c0bf8,
            0x00d9f5bb8a87c46f08d683ee5d068c61c24c2613cd38e646fcc5066292047c0c
        ]
    );
    assert(
        x5_4(
        [
        0x27b40f5ae800e9829ace2a1b67139701fb7844c77efba81687922f6c1d1283f7,
        0x0f2508ee9cfb0cf50fae054fd47eed2109affbc78f3447d7b05c9942bd575386,
        0x159e446ff64cd50562c5b7696c880451c6a4ae721dace6ce3522dc61166f0eb7,
        0x2088b849d0414664f725300e170139be1a130a8789c051d87d3016a0103d7063
    ]
    )
        == [
            0x02b23ee47a8886f71df5c1effcef53fcf94e20e44b424032ea208d1bcb9245a6,
            0x04a86f98792475ee1fb88b5ef20ff580fe193f577be99fbc2716b27aaa270ac0,
            0x0f31f524399d827d100ea64311940c7956b298e83133ee39ee68a16ecf7d3d96,
            0x07ed3d1cbc615777625cf89f40f8bccf277765a822590509b81f68b00c2acfd5
        ]
    );
    assert(
        x5_4(
        [
        0x209a9c3e15bec625126dc8b0d0f9f95ea2b9de1e7b8d4c53ee1717beabd33f04,
        0x24ccb37f3ce622575174157f05e0eb8b81f82ee03eb1e41cd15041bfaca1b5d9,
        0x0ea2ddca7af5936d6455b202eccf6b18ff5880a9c08a5fb2d586051c750f21e9,
        0x1648a906515843061122690577b18ada557f1291f5219cffd525b5ff4b9842fa
    ]
    )
        == [
            0x1a6e03e2f72b070328c30460f06d5fd7feebfb9d7ab3a8f39f5e109ee7af7f26,
            0x14cc9f81796d9d82041860efd2c452322993c35ed47c42fc0ea93326e2bf0841,
            0x1aaec29e883b431ac7c175afd61762603493dbf41eaeed4307eca90207fe3acd,
            0x185c077435508be2957467b0ef5f7688990e2fbd261604088806f860e130cd8f
        ]
    );
    assert(
        x5_4(
        [
        0x199f543dac3759aff3d23dd1d9dbc15054003ee215c622b5a965771858aa9b63,
        0x02cb160115433d5057639349d232e92d38aed667614ef0e2c929521813d551b7,
        0x19185f94aa2ea1ba997771d0e127b14be7cc46cc9ae0ae184a4c5a6a02d33ed3,
        0x22931b30cffa3dc7629ee16edd1b2f4360eaef3f65a9c0c77712cad3bcb7681d
    ]
    )
        == [
            0x081cdd125d9684c9708bbd27859294859464184ea1790524cb7cf3ddacfac8ee,
            0x30066d6d1de7b676566df7729f60f8c98fab3847c302b4a8043468dd3bf7b69b,
            0x28a0834350d5ee6389736292b7900eb877e1d90d0b1423ec1f7aa39470a917ae,
            0x19e8fbab4c5c61d0bb3142d8c7476c0a17dd3f65f95ba53d61de4d541b8c6150
        ]
    );
    assert(
        x5_4(
        [
        0x0b86348715725a9d3daaa703d4f69c48b9d59e91b340ffaa900c56db2873299e,
        0x14d170ac34a883e44f29da63d541c76329929994ec49c9a4fc107d0cefbd261e,
        0x10af6a15db6f8f33c8f9a5daf58f83960d3dee74bb46b480330cddd1efd55712,
        0x00952f86ce8cee6fa48fa9e8a18f439ab1ea0d75f3ab1238797901109a16c1cf
    ]
    )
        == [
            0x2fce2a4166fd6c1218b12252d0e09fa2e0d8d3f39314366f1fe36efffeb4f163,
            0x1ddf7f67c10bdd97b08585fa656aba8b49364bf512e5bf75ad0a49cb550dae4e,
            0x13001073ce009c9233f922b2c28a3713d9a166ed237c80a4567a14e00c2b8bbf,
            0x079aa5d4930a442eb1f9d6aa7d4f6d38305480b43283359ef3df4e0a9e1e4582
        ]
    );
    assert(
        x5_4(
        [
        0x1016b6df09c91d69260da1326af6c2d19d412062c5b6d0f412f3ce064eb6f917,
        0x1265649c4e9d05d7ad84900a238b51914695649aba45ee20f7432c5100c3ee20,
        0x2d078a7a4c1826881f4187620c91c6e67f9b2324686e0d94defa1d14b30217d9,
        0x0d22fb80b97d62e617643904af2835789c3fb8a6b9b2182fb50cf6c7f2f1b84c
    ]
    )
        == [
            0x2125822f49c88f7c2e2a7647166666be17370d3fa856b53eb04016a93e753d6f,
            0x0c504cfeb76111539bc55b8c076ed94e7894c26ab0c0ece174e1b46c848ca502,
            0x0413adfe3cab1b084926677c07aaa5256e4ef7fee2f7d5aa3723614175f7ffad,
            0x15c1fbe85f29b109616b4bff0e358ef216d8f3979d3ce304fca53e2a0ee443d3
        ]
    );
    assert(
        x5_4(
        [
        0x000e4b869b520b451065176472c7d1b1dcee5dc8bc412f4b21ffa14de3da25d7,
        0x0f43ce0e8832046144e81b20607fc32d499bc8ee8bfabf908fd293cc1481f9dc,
        0x070dd87287ed4a85aad2eba0021bc7e38f28af8df7e0efe73977a765bf9c76cf,
        0x00f815d55562cd62cd255f3de644699bb67b98419c3f7c51f7d8d7c93f1ab6ab
    ]
    )
        == [
            0x2290c68610797530389c29fd75dbc1173cfb5edd512e3305c0fbcf32b041dc79,
            0x06c108c18db565be2dbda952ee042abb608d9e3d67b6be7d940f5cee6164e754,
            0x24e9cd335be0aff74d864ed6354bd230a14ca2470407f2a553964a1a696f429e,
            0x08f23ec21d64b1c17aea20b96c7f47cba4bfa4dd42ccb8bd68237e508bd45f60
        ]
    );
}

#[test]
fn test_perm_3() {
    assert(
        x5_3([0, 1, 2]) == [
            0x1eca43adaa40dd2e3ab7eed8dadf345d05d9d0cbfc4580fe7c6d08c96f7718aa,
            0x2c94545a7f257006211a040c7d7dba6c5ebbc62dae694d4378df34ec1e22c282,
            0x2bfce23660c70dce9866f349c597eb2cbf07fe0c54d365eee0a3953349e3bb0d
        ]
    );
    assert(
        x5_3(
        [
        0x2f2c9bf7f096b9ded61dd9e99acc30248ea4e1afb464d60cfe2622baf51507ae,
        0x2f79c13e6dc8a06f0e4eec0d53905e0aa16857e5815f63d5e4d1946cc66b6744,
        0x0b7d1c0319380d5f668e4c7f35e9252cd237c6350d913f962460bf03814d94cf
    ]
    )
        == [
            0x0e2fad356b586544f054f780d350f9b402055d239c9179224c08b984463a36e9,
            0x2f2c7075f2c0cc159f7a80da7173969c5abb5268c5a595675666715d21d7c7fc,
            0x0d5be0651b0219b3be88bcfeae80a84e3512e365722d44071d69db25a5f98925
        ]
    );
    assert(
        x5_3(
        [
        0x11897a7f1d718a427c160ffdb3b566d00e73d3f3eafe3e7de7f4f94fb5fe2d2c,
        0x06eef02a6a808f2db996724ac60a958dcf7361f2359ed2db8a7420b7f59b9109,
        0x2148b7e6122df6b68b9c32b5bfc1df366ede59eba4c9d9c093998afd6471bb4b
    ]
    )
        == [
            0x040ed1e9e258beb4203e401a68bec610ace085d6b49fd14901ca8a1e9a11fafb,
            0x19bd17c1fbdad0ae01c4734adbab9581a6c9052ed340b28d51e5d52e1572b147,
            0x28f6f009d761c159671abeae800bd3be49efbcd1cb6f9366374f67e37e793dc4
        ]
    );
    assert(
        x5_3(
        [
        0x0374dd018337b04af6d854dc4645ac71d1d0c5262766ee1400634776b95d685e,
        0x06053c8d5fa000eaa82d21c22279ac52bfe183a23686a9f58d6b1641cb4b1b99,
        0x2184bd596ddb9e0a84d7b88b13b62c97eb5f9921da1f5d36a690a18c963d2e28
    ]
    )
        == [
            0x17e0085067f0fbb3f7307bf78a05ecdcdbb65cf9161571d2d196b966dd69716f,
            0x10e242e4983345119acee4632c10867c18973a13e8987d20c227882186843552,
            0x16ebecbd7696bd80a2f72130ce70a0685ccafcdab29e6bdb6c5458c85af39310
        ]
    );
    assert(
        x5_3(
        [
        0x0d3c541c9e880be58a833788c67195efdbf2c07141694eb29753e72b7735ee85,
        0x1deb65809052e4f11ccb5ff8f974d2bd324aae652cbe6bd4ebbad13fe761d2be,
        0x2c166fa6f3ad3db2c3a2f8dd728e85e198ec7778db395b2d5caefd66bcee0e1e
    ]
    )
        == [
            0x16ab52fa15fde26527fe6f33beb031ad8466fc6ced6dfb467db0f9c470a660bf,
            0x0ef4b034fb53bf8da5b6b09b178b457244a57fe3ea72564a2bdf8453ba6fffe7,
            0x28869ae3f3c885f4391d4210e4ebe03040d15c337a35de70d34a80732a4d668d
        ]
    );
    assert(
        x5_3(
        [
        0x18864aa9753ff1ad01a8ccfceab1d9ff9a1d9e5bf642731f20b990abf6f5d7be,
        0x2db95f2ca671f3189109f554d1c99f4bcf2b54e19a9196379c7f4f5c034dcf5c,
        0x24931a2962a2d9f3fcee7a919311e85637e55d0f9a8f868ac4b4c9d304ce48a5
    ]
    )
        == [
            0x1fc636a7ffaf7e8958139f7f97ad1e5828f3a7532dc47a37a0f06bc774358d17,
            0x283d827c18c93433de937e51f4b65a484395d75e3490435437be7bcafd9f087d,
            0x1ccb33b0bf3f7fc6c2baf1b388b8c6e1e256ecfe62defc67ceaf3f24ee709151
        ]
    );
    assert(
        x5_3(
        [
        0x1e873550c9ca8d2420e539eda925fea4928becbd95ff76d1708b5bde54c23579,
        0x037212f6b54387f045bb0142908a58a89ada0f2b6c8e67fc5d2c7407452eaab5,
        0x02c2d3d1bf6117e7423b56f891850540c0e202d09d306deb20d22f1f41bca53b
    ]
    )
        == [
            0x1e4af67569422335eb8b9a1295f8ec355199a1b0f50881af69d6f0b9c2996d40,
            0x20ba4340b081e034cf58eeeb865cd822d5b565c715ad49313e1c2a74b604bd81,
            0x09b6626fea603eb74145ab34b10824db0c3777c317afa90e3c8abd93ad73b0cd
        ]
    );
    assert(
        x5_3(
        [
        0x0ae36f45c2f7f4b610a1967770cb9a83f35d48d75cbb0fd902af2febc2aa2e06,
        0x287bcf4814f8c5dc1e2a52f2c493ab5f84f56cb9ad262ad66f877e0e672abf20,
        0x1bf87b70402ebd491e6d94191b8ca732ac02f6e36309c44d728d96c6ace4774c
    ]
    )
        == [
            0x1a629529755b006129fd6c06b169de6bd75eee9773d8864c4695030999300ed5,
            0x1c545631273123530eea55f6ecb3cf9890348062255ba84e2426fb3df547a5d5,
            0x25b4bbaa5c88454d617032e7f10a422c9536a74c935e6830d4cdad2f237cde97
        ]
    );
    assert(
        x5_3(
        [
        0x0351296e65f25d4e85086fca297696e202dbe5329aa54dd7c96a789cff97c57b,
        0x2eb3fef0bf6c531d588b15a90e24e0fd4676270567259b2dd2bdf4948a44d964,
        0x0d98f7e6fe13c78d33fc2e47daf833bfb212134f4cb7be808738d0a439cf65fc
    ]
    )
        == [
            0x2f0ce2ff0ddc08467c904f9927e5ed4e0dd9d9185106bbb05dfc7c436de35177,
            0x043d560f08901ac4e7536400728b17f1d934037f4e8f1c3ca26d3600f4301651,
            0x280375d9bdcc0c7cad539e734c0de2eed4d74a4d6681254eabf2357df263297e
        ]
    );
    assert(
        x5_3(
        [
        0x0be972afb0965c653c1575a970de1184f074ea04d5d3ce296e92a4d48bef8a8c,
        0x1c9d565d61b600db9a47e746dace8b2d6d7485898a5749afecf91d861ca2511f,
        0x29ef00689cd2ea5a2c9c0ee5e79fe31692fe294bfe7f8ca04aedc4bd6583107e
    ]
    )
        == [
            0x29b8a65cfa31fe8ffe66283d51915b7733514155c38f3f376a896a9ebf16f4a5,
            0x256dd0c5247958335835bce048bd0c844fb11bc6c04609b9e03dbb14359f8a63,
            0x23a7fd6f723642c1847cae825710fad5ac70d3836192ee2be326a83b47d80f60
        ]
    );
    assert(
        x5_3(
        [
        0x251caaebb054a9c53545de2df565b1ff3516324f736f349238e1abad4354dd90,
        0x1e3d43917935c07bf3fd234ea7a3a62a8776183ab9ea356054bb32f235f5cfe1,
        0x135e44bc5a2f4d70d2799fe6927d8d6e1c72debd938d4142c70d45c383fe9a37
    ]
    )
        == [
            0x175aceb804bcf85ad93fc0153d607c8c176e9f5a80715768347cf63333891d60,
            0x2e13aff9bf08e413283cd68d0e2e4a151c95d470318e1424c4159b3861baf44f,
            0x1ee59fe529fe0a2910e8d5d8f47025d1d85450ed78925bb4b6ab4f12b81586b8
        ]
    );
}
