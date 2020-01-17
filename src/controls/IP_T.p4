control IPv4_TUNNEL(inout header_t hdr, inout ingress_metadata_t ig_md, inout ingress_intrinsic_metadata_for_tm_t ig_tm_md, in ingress_intrinsic_metadata_t ig_intr_md, inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md) {
    action forward(PortId_t port) {
        ig_tm_md.ucast_egress_port = port;

        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }

    action decap() {
         hdr.ipv4_inner.identification = hdr.ipv4.identification; // for evaluation purpose
         hdr.ipv4.setInvalid(); // remove ipv4 header
         hdr.ethernet.ether_type = ETHERTYPE_PROTECTION;
    }

    table ipv4_tunnel {
        key = {
            hdr.ipv4.dstAddr: exact;
        }
        actions = {
            forward;
            decap;
        }
    }


    apply {
        ipv4_tunnel.apply();
    }
}
