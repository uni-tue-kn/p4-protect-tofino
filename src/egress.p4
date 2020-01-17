#include "controls/Mac.p4"


control egress(
        inout header_t hdr,
        inout egress_metadata_t eg_md,
        in egress_intrinsic_metadata_t eg_intr_md,
        in egress_intrinsic_metadata_from_parser_t eg_intr_from_prsr,
        inout egress_intrinsic_metadata_for_deparser_t eg_intr_md_for_dprsr,
        inout egress_intrinsic_metadata_for_output_port_t eg_intr_md_for_oport) {

    Mac() mac_c;

    apply {
        if(DEVICE_TYPE == 1) {
            hdr.ipv4.srcAddr = (bit<32>) (eg_intr_from_prsr.global_tstamp - hdr.ethernet.src_addr);
        }
        else {
            hdr.ipv4.identification = (bit<16>) (eg_intr_from_prsr.global_tstamp - hdr.ethernet.src_addr);
        }
       
        mac_c.apply(hdr, eg_intr_md);
        
    }
}
