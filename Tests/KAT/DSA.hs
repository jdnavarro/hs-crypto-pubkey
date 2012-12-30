{-# LANGUAGE OverloadedStrings #-}
module KAT.DSA (dsaTests) where

import Data.ByteString (ByteString)
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC

import qualified Crypto.PubKey.DSA as DSA
import qualified Crypto.Hash.SHA1 as SHA1

import Test.HUnit
import Test.Framework (Test, testGroup)
import Test.Framework.Providers.HUnit (testCase)

data VectorDSA = VectorDSA
    { pgq :: DSA.Params
    , msg :: ByteString
    , x :: Integer
    , y :: Integer
    , k :: Integer
    , r :: Integer
    , s :: Integer
    }

vectorsSHA1 =
    [ VectorDSA
        { msg = "\x3b\x46\x73\x6d\x55\x9b\xd4\xe0\xc2\xc1\xb2\x55\x3a\x33\xad\x3c\x6c\xf2\x3c\xac\x99\x8d\x3d\x0c\x0e\x8f\xa4\xb1\x9b\xca\x06\xf2\xf3\x86\xdb\x2d\xcf\xf9\xdc\xa4\xf4\x0a\xd8\xf5\x61\xff\xc3\x08\xb4\x6c\x5f\x31\xa7\x73\x5b\x5f\xa7\xe0\xf9\xe6\xcb\x51\x2e\x63\xd7\xee\xa0\x55\x38\xd6\x6a\x75\xcd\x0d\x42\x34\xb5\xcc\xf6\xc1\x71\x5c\xca\xaf\x9c\xdc\x0a\x22\x28\x13\x5f\x71\x6e\xe9\xbd\xee\x7f\xc1\x3e\xc2\x7a\x03\xa6\xd1\x1c\x5c\x5b\x36\x85\xf5\x19\x00\xb1\x33\x71\x53\xbc\x6c\x4e\x8f\x52\x92\x0c\x33\xfa\x37\xf4\xe7"
        , x = 0xc53eae6d45323164c7d07af5715703744a63fc3a
        , y = 0x313fd9ebca91574e1c2eebe1517c57e0c21b0209872140c5328761bbb2450b33f1b18b409ce9ab7c4cd8fda3391e8e34868357c199e16a6b2eba06d6749def791d79e95d3a4d09b24c392ad89dbf100995ae19c01062056bb14bce005e8731efde175f95b975089bdcdaea562b32786d96f5a31aedf75364008ad4fffebb970b
        , k = 0x98cbcc4969d845e2461b5f66383dd503712bbcfa
        , r = 0x50ed0e810e3f1c7cb6ac62332058448bd8b284c0
        , s = 0xc6aded17216b46b7e4b6f2a97c1ad7cc3da83fde
        , pgq = dsaParams
        }
    , VectorDSA
        { msg = "\xd2\xbc\xb5\x3b\x04\x4b\x3e\x2e\x4b\x61\xba\x2f\x91\xc0\x99\x5f\xb8\x3a\x6a\x97\x52\x5e\x66\x44\x1a\x3b\x48\x9d\x95\x94\x23\x8b\xc7\x40\xbd\xee\xa0\xf7\x18\xa7\x69\xc9\x77\xe2\xde\x00\x38\x77\xb5\xd7\xdc\x25\xb1\x82\xae\x53\x3d\xb3\x3e\x78\xf2\xc3\xff\x06\x45\xf2\x13\x7a\xbc\x13\x7d\x4e\x7d\x93\xcc\xf2\x4f\x60\xb1\x8a\x82\x0b\xc0\x7c\x7b\x4b\x5f\xe0\x8b\x4f\x9e\x7d\x21\xb2\x56\xc1\x8f\x3b\x9d\x49\xac\xc4\xf9\x3e\x2c\xe6\xf3\x75\x4c\x78\x07\x75\x7d\x2e\x11\x76\x04\x26\x12\xcb\x32\xfc\x3f\x4f\x70\x70\x0e\x25"
        , x = 0xe65131d73470f6ad2e5878bdc9bef536faf78831
        , y = 0x29bdd759aaa62d4bf16b4861c81cf42eac2e1637b9ecba512bdbc13ac12a80ae8de2526b899ae5e4a231aef884197c944c732693a634d7659abc6975a773f8d3cd5a361fe2492386a3c09aaef12e4a7e73ad7dfc3637f7b093f2c40d6223a195c136adf2ea3fbf8704a675aa7817aa7ec7f9adfb2854d4e05c3ce7f76560313b
        , k = 0x87256a64e98cf5be1034ecfa766f9d25d1ac7ceb
        , r = 0xa26c00b5750a2d27fe7435b93476b35438b4d8ab
        , s = 0x61c9bfcb2938755afa7dad1d1e07c6288617bf70
        , pgq = dsaParams
        }
    , VectorDSA
        { msg = "\xd5\x43\x1e\x6b\x16\xfd\xae\x31\x48\x17\x42\xbd\x39\x47\x58\xbe\xb8\xe2\x4f\x31\x94\x7e\x19\xb7\xea\x7b\x45\x85\x21\x88\x22\x70\xc1\xf4\x31\x92\xaa\x05\x0f\x44\x85\x14\x5a\xf8\xf3\xf9\xc5\x14\x2d\x68\xb8\x50\x18\xd2\xec\x9c\xb7\xa3\x7b\xa1\x2e\xd2\x3e\x73\xb9\x5f\xd6\x80\xfb\xa3\xc6\x12\x65\xe9\xf5\xa0\xa0\x27\xd7\x0f\xad\x0c\x8a\xa0\x8a\x3c\xbf\xbe\x99\x01\x8d\x00\x45\x38\x61\x73\xe5\xfa\xe2\x25\xfa\xeb\xe0\xce\xf5\xdd\x45\x91\x0f\x40\x0a\x86\xc2\xbe\x4e\x15\x25\x2a\x16\xde\x41\x20\xa2\x67\xbe\x2b\x59\x4d"
        , x = 0x20bcabc6d9347a6e79b8e498c60c44a19c73258c
        , y = 0x23b4f404aa3c575e550bb320fdb1a085cd396a10e5ebc6771da62f037cab19eacd67d8222b6344038c4f7af45f5e62b55480cbe2111154ca9697ca76d87b56944138084e74c6f90a05cf43660dff8b8b3fabfcab3f0e4416775fdf40055864be102b4587392e77752ed2aeb182ee4f70be4a291dbe77b84a44ee34007957b1e0
        , k = 0x7d9bcfc9225432de9860f605a38d389e291ca750
        , r = 0x3f0a4ad32f0816821b8affb518e9b599f35d57c2
        , s = 0xea06638f2b2fc9d1dfe99c2a492806b497e2b0ea
        , pgq = dsaParams
        }
    , VectorDSA
        { msg = "\x85\x66\x2b\x69\x75\x50\xe4\x91\x5c\x29\xe3\x38\xb6\x24\xb9\x12\x84\x5d\x6d\x1a\x92\x0d\x9e\x4c\x16\x04\xdd\x47\xd6\x92\xbc\x7c\x0f\xfb\x95\xae\x61\x4e\x85\x2b\xeb\xaf\x15\x73\x75\x8a\xd0\x1c\x71\x3c\xac\x0b\x47\x6e\x2f\x12\x17\x45\xa3\xcf\xee\xff\xb2\x44\x1f\xf6\xab\xfb\x9b\xbe\xb9\x8a\xa6\x34\xca\x6f\xf5\x41\x94\x7d\xcc\x99\x27\x65\x9d\x44\xf9\x5c\x5f\xf9\x17\x0f\xdc\x3c\x86\x47\x3c\xb6\x01\xba\x31\xb4\x87\xfe\x59\x36\xba\xc5\xd9\xc6\x32\xcb\xcc\x3d\xb0\x62\x46\xba\x01\xc5\x5a\x03\x8d\x79\x7f\xe3\xf6\xc3"
        , x = 0x52d1fbe687aa0702a51a5bf9566bd51bd569424c
        , y = 0x6bc36cb3fa61cecc157be08639a7ca9e3de073b8a0ff23574ce5ab0a867dfd60669a56e60d1c989b3af8c8a43f5695d503e3098963990e12b63566784171058eace85c728cd4c08224c7a6efea75dca20df461013c75f40acbc23799ebee7f3361336dadc4a56f305708667bfe602b8ea75a491a5cf0c06ebd6fdc7161e10497
        , k = 0x960c211891c090d05454646ebac1bfe1f381e82b
        , r = 0x3bc29dee96957050ba438d1b3e17b02c1725d229
        , s = 0x0af879cf846c434e08fb6c63782f4d03e0d88865
        , pgq = dsaParams
        }
    , VectorDSA
        { msg = "\x87\xb6\xe7\x5b\x9f\x8e\x99\xc4\xdd\x62\xad\xb6\x93\xdd\x58\x90\xed\xff\x1b\xd0\x02\x8f\x4e\xf8\x49\xdf\x0f\x1d\x2c\xe6\xb1\x81\xfc\x3a\x55\xae\xa6\xd0\xa1\xf0\xae\xca\xb8\xed\x9e\x24\x8a\x00\xe9\x6b\xe7\x94\xa7\xcf\xba\x12\x46\xef\xb7\x10\xef\x4b\x37\x47\x1c\xef\x0a\x1b\xcf\x55\xce\xbc\x8d\x5a\xd0\x71\x61\x2b\xd2\x37\xef\xed\xd5\x10\x23\x62\xdb\x07\xa1\xe2\xc7\xa6\xf1\x5e\x09\xfe\x64\xba\x42\xb6\x0a\x26\x28\xd8\x69\xae\x05\xef\x61\x1f\xe3\x8d\x9c\xe1\x5e\xee\xc9\xbb\x3d\xec\xc8\xdc\x17\x80\x9f\x3b\x6e\x95"
        , x = 0xc86a54ec5c4ec63d7332cf43ddb082a34ed6d5f5
        , y = 0x014ac746d3605efcb8a2c7dae1f54682a262e27662b252c09478ce87d0aaa522d7c200043406016c0c42896d21750b15dbd57f9707ec37dcea5651781b67ad8d01f5099fe7584b353b641bb159cc717d8ceb18b66705e656f336f1214b34f0357e577ab83641969e311bf40bdcb3ffd5e0bb59419f229508d2f432cc2859ff75
        , k = 0x6c445cee68042553fbe63be61be4ddb99d8134af
        , r = 0x637e07a5770f3dc65e4506c68c770e5ef6b8ced3
        , s = 0x7dfc6f83e24f09745e01d3f7ae0ed1474e811d47
        , pgq = dsaParams
        }
    , VectorDSA
        { msg = "\x22\x59\xee\xad\x2d\x6b\xbc\x76\xd4\x92\x13\xea\x0d\xc8\xb7\x35\x0a\x97\x69\x9f\x22\x34\x10\x44\xc3\x94\x07\x82\x36\x4a\xc9\xea\x68\x31\x79\xa4\x38\xa5\xea\x45\x99\x8d\xf9\x7c\x29\x72\xda\xe0\x38\x51\xf5\xbe\x23\xfa\x9f\x04\x18\x2e\x79\xdd\xb2\xb5\x6d\xc8\x65\x23\x93\xec\xb2\x7f\x3f\x3b\x7c\x8a\x8d\x76\x1a\x86\xb3\xb8\xf4\xd4\x1a\x07\xb4\xbe\x7d\x02\xfd\xde\xfc\x42\xb9\x28\x12\x4a\x5a\x45\xb9\xf4\x60\x90\x42\x20\x9b\x3a\x7f\x58\x5b\xd5\x14\xcc\x39\xc0\x0e\xff\xcc\x42\xc7\xfe\x70\xfa\x83\xed\xf8\xa3\x2b\xf4"
        , x = 0xaee6f213b9903c8069387e64729a08999e5baf65
        , y = 0x0fe74045d7b0d472411202831d4932396f242a9765e92be387fd81bbe38d845054528b348c03984179b8e505674cb79d88cc0d8d3e8d7392f9aa773b29c29e54a9e326406075d755c291fcedbcc577934c824af988250f64ed5685fce726cff65e92d708ae11cbfaa958ab8d8b15340a29a137b5b4357f7ed1c7a5190cbf98a4
        , k = 0xe1704bae025942e2e63c6d76bab88da79640073a
        , r = 0x83366ba3fed93dfb38d541203ecbf81c363998e2
        , s = 0x1fe299c36a1332f23bf2e10a6c6a4e0d3cdd2bf4
        , pgq = dsaParams
        } 
    , VectorDSA
        { msg = "\x21\x9e\x8d\xf5\xbf\x88\x15\x90\x43\x0e\xce\x60\x82\x50\xf7\x67\x0d\xc5\x65\x37\x24\x93\x02\x42\x9e\x28\xec\xfe\xb9\xce\xaa\xa5\x49\x10\xa6\x94\x90\xf7\x65\xf3\xdf\x82\xe8\xb0\x1c\xd7\xd7\x6e\x56\x1d\x0f\x6c\xe2\x26\xef\x3c\xf7\x52\xca\xda\x6f\xeb\xdc\x5b\xf0\x0d\x67\x94\x7f\x92\xd4\x20\x51\x6b\x9e\x37\xc9\x6c\x8f\x1f\x2d\xa0\xb0\x75\x09\x7c\x3b\xda\x75\x8a\x8d\x91\xbd\x2e\xbe\x9c\x75\xcf\x14\x7f\x25\x4c\x25\x69\x63\xb3\x3b\x67\xd0\x2b\x6a\xa0\x9e\x7d\x74\x65\xd0\x38\xe5\x01\x95\xec\xe4\x18\x9b\x41\xe7\x68"
        , x = 0x699f1c07aa458c6786e770b40197235fe49cf21a
        , y = 0x3a41b0678ff3c4dde20fa39772bac31a2f18bae4bedec9e12ee8e02e30e556b1a136013bef96b0d30b568233dcecc71e485ed75c922afb4d0654e709bee84993792130220e3005fdb06ebdfc0e2df163b5ec424e836465acd6d92e243c86f2b94b26b8d73bd9cf722c757e0b80b0af16f185de70e8ca850b1402d126ea60f309
        , k = 0x5bbb795bfa5fa72191fed3434a08741410367491
        , r = 0x579761039ae0ddb81106bf4968e320083bbcb947
        , s = 0x503ea15dbac9dedeba917fa8e9f386b93aa30353
        , pgq = dsaParams
        } 
    , VectorDSA
        { msg = "\x2d\xa7\x9d\x06\x78\x85\xeb\x3c\xcf\x5e\x29\x3a\xe3\xb1\xd8\x22\x53\x22\x20\x3a\xbb\x5a\xdf\xde\x3b\x0f\x53\xbb\xe2\x4c\x4f\xe0\x01\x54\x1e\x11\x83\xd8\x70\xa9\x97\xf1\xf9\x46\x01\x00\xb5\xd7\x11\x92\x31\x80\x15\x43\x45\x28\x7a\x02\x14\xcf\x1c\xac\x37\xb7\xa4\x7d\xfb\xb2\xa0\xe8\xce\x49\x16\xf9\x4e\xbd\x6f\xa5\x4e\x31\x5b\x7a\x8e\xb5\xb6\x3c\xd9\x54\xc5\xba\x05\xc1\xbf\x7e\x33\xa4\xe8\xa1\x51\xf3\x2d\x28\x77\xb0\x17\x29\xc1\xad\x0e\x7c\x01\xbb\x8a\xe7\x23\xc9\x95\x18\x38\x03\xe4\x56\x36\x52\x0e\xa3\x8c\xa1"
        , x = 0xd6e08c20c82949ddba93ea81eb2fea8c595894dc
        , y = 0x56f7272210f316c51af8bfc45a421fd4e9b1043853271b7e79f40936f0adcf262a86097aa86e19e6cb5307685d863dba761342db6c973b3849b1e060aca926f41fe07323601062515ae85f3172b8f34899c621d59fa21f73d5ae97a3deb5e840b25a18fd580862fd7b1cf416c7ae9fc5842a0197fdb0c5173ff4a4f102a8cf89
        , k = 0x6d72c30d4430959800740f2770651095d0c181c2
        , r = 0x5dd90d69add67a5fae138eec1aaff0229aa4afc4
        , s = 0x47f39c4db2387f10762f45b80dfd027906d7ef04
        , pgq = dsaParams
        } 
    , VectorDSA
        { msg = "\xba\x30\xd8\x5b\xe3\x57\xe7\xfb\x29\xf8\xa0\x7e\x1f\x12\x7b\xaa\xa2\x4b\x2e\xe0\x27\xf6\x4c\xb5\xef\xee\xc6\xaa\xea\xbc\xc7\x34\x5c\x5d\x55\x6e\xbf\x4b\xdc\x7a\x61\xc7\x7c\x7b\x7e\xa4\x3c\x73\xba\xbc\x18\xf7\xb4\x80\x77\x22\xda\x23\x9e\x45\xdd\xf2\x49\x84\x9c\xbb\xfe\x35\x07\x11\x2e\xbf\x87\xd7\xef\x56\x0c\x2e\x7d\x39\x1e\xd8\x42\x4f\x87\x10\xce\xa4\x16\x85\x14\x3e\x30\x06\xf8\x1b\x68\xfb\xb4\xd5\xf9\x64\x4c\x7c\xd1\x0f\x70\x92\xef\x24\x39\xb8\xd1\x8c\x0d\xf6\x55\xe0\x02\x89\x37\x2a\x41\x66\x38\x5d\x64\x0c"
        , x = 0x50018482864c1864e9db1f04bde8dbfd3875c76d
        , y = 0x0942a5b7a72ab116ead29308cf658dfe3d55d5d61afed9e3836e64237f9d6884fdd827d2d5890c9a41ae88e7a69fc9f345ade9c480c6f08cff067c183214c227236cedb6dd1283ca2a602574e8327510221d4c27b162143b7002d8c726916826265937b87be9d5ec6d7bd28fb015f84e0ab730da7a4eaf4ef3174bf0a22a6392
        , k = 0xdf3a9348f37b5d2d4c9176db266ae388f1fa7e0f
        , r = 0x448434b214eee38bde080f8ec433e8d19b3ddf0d
        , s = 0x0c02e881b777923fe0ea674f2621298e00199d5f
        , pgq = dsaParams
        } 
    , VectorDSA
        { msg = "\x83\x49\x9e\xfb\x06\xbb\x7f\xf0\x2f\xfb\x46\xc2\x78\xa5\xe9\x26\x30\xac\x5b\xc3\xf9\xe5\x3d\xd2\xe7\x8f\xf1\x5e\x36\x8c\x7e\x31\xaa\xd7\x7c\xf7\x71\xf3\x5f\xa0\x2d\x0b\x5f\x13\x52\x08\xa4\xaf\xdd\x86\x7b\xb2\xec\x26\xea\x2e\x7d\xd6\x4c\xde\xf2\x37\x50\x8a\x38\xb2\x7f\x39\xd8\xb2\x2d\x45\xca\xc5\xa6\x8a\x90\xb6\xea\x76\x05\x86\x45\xf6\x35\x6a\x93\x44\xd3\x6f\x00\xec\x66\x52\xea\xa4\xe9\xba\xe7\xb6\x94\xf9\xf1\xfc\x8c\x6c\x5e\x86\xfa\xdc\x7b\x27\xa2\x19\xb5\xc1\xb2\xae\x80\xa7\x25\xe5\xf6\x11\x65\xfe\x2e\xdc"
        , x = 0xae56f66b0a9405b9cca54c60ec4a3bb5f8be7c3f
        , y = 0xa01542c3da410dd57930ca724f0f507c4df43d553c7f69459939685941ceb95c7dcc3f175a403b359621c0d4328e98f15f330a63865baf3e7eb1604a0715e16eed64fd14b35d3a534259a6a7ddf888c4dbb5f51bbc6ed339e5bb2a239d5cfe2100ac8e2f9c16e536f25119ab435843af27dc33414a9e4602f96d7c94d6021cec
        , k = 0x8857ff301ad0169d164fa269977a116e070bac17
        , r = 0x8c2fab489c34672140415d41a65cef1e70192e23
        , s = 0x3df86a9e2efe944a1c7ea9c30cac331d00599a0e
        , pgq = dsaParams
        } 
    ]
    where -- (p,g,q)
          dsaParams = (0xa8f9cd201e5e35d892f85f80e4db2599a5676a3b1d4f190330ed3256b26d0e80a0e49a8fffaaad2a24f472d2573241d4d6d6c7480c80b4c67bb4479c15ada7ea8424d2502fa01472e760241713dab025ae1b02e1703a1435f62ddf4ee4c1b664066eb22f2e3bf28bb70a2a76e4fd5ebe2d1229681b5b06439ac9c7e9d8bde283,0x2b3152ff6c62f14622b8f48e59f8af46883b38e79b8c74deeae9df131f8b856e3ad6c8455dab87cc0da8ac973417ce4f7878557d6cdf40b35b4a0ca3eb310c6a95d68ce284ad4e25ea28591611ee08b8444bd64b25f3f7c572410ddfb39cc728b9c936f85f419129869929cdb909a6a3a99bbe089216368171bd0ba81de4fe33, 0xf85f0f83ac4df7ea0cdf8f469bfeeaea14156495)

vectorToPrivate :: VectorDSA -> DSA.PrivateKey
vectorToPrivate vector = DSA.PrivateKey
    { DSA.private_x      = x vector
    , DSA.private_params = pgq vector
    }

vectorToPublic :: VectorDSA -> DSA.PublicKey
vectorToPublic vector = DSA.PublicKey
    { DSA.public_y      = y vector
    , DSA.public_params = pgq vector
    }

doSignatureTest (i, vector) = testCase (show i) (expected @=? actual)
    where expected = Just (r vector, s vector)
          actual   = DSA.signWith (k vector) (vectorToPrivate vector) SHA1.hash (msg vector)

doVerifyTest (i, vector) = testCase (show i) (True @=? actual)
    where actual = DSA.verify SHA1.hash (vectorToPublic vector) (r vector, s vector) (msg vector)

dsaTests = testGroup "DSA"
    [ testGroup "SHA1"
        [ testGroup "signature" $ map doSignatureTest (zip [0..] vectorsSHA1)
        , testGroup "verify" $ map doVerifyTest (zip [0..] vectorsSHA1)
        ]
    ]
