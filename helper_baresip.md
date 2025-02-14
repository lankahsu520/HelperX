# [baresip](https://github.com/baresip/baresip)
[![](https://img.shields.io/badge/Powered%20by-lankahsu%20-brightgreen.svg)](https://github.com/lankahsu520/HelperX)
[![GitHub license][license-image]][license-url]
[![GitHub stars][stars-image]][stars-url]
[![GitHub forks][forks-image]][forks-url]
[![GitHub issues][issues-image]][issues-image]
[![GitHub watchers][watchers-image]][watchers-image]

[license-image]: https://img.shields.io/github/license/lankahsu520/HelperX.svg
[license-url]: https://github.com/lankahsu520/HelperX/blob/master/LICENSE
[stars-image]: https://img.shields.io/github/stars/lankahsu520/HelperX.svg
[stars-url]: https://github.com/lankahsu520/HelperX/stargazers
[forks-image]: https://img.shields.io/github/forks/lankahsu520/HelperX.svg
[forks-url]: https://github.com/lankahsu520/HelperX/network
[issues-image]: https://img.shields.io/github/issues/lankahsu520/HelperX.svg
[issues-url]: https://github.com/lankahsu520/HelperX/issues
[watchers-image]: https://img.shields.io/github/watchers/lankahsu520/HelperX.svg
[watchers-url]: https://github.com/lankahsu520/HelperX/watchers

# 1. Overview

> Baresip is a portable and modular SIP User-Agent with audio and video support. 

> 體會過 baresip 後，覺得在編譯和修改非常容易上手。縱觀其它 sip client(s)，不只編譯困難，引用的 open source 過多過舊，甚至已沒有維護，更重要的就是連怎麼執行都不交待，

```mermaid
flowchart LR
	baresip[baresip]
	linphone[linphone]

	SServers[SIP Servers]

	baresip <--> SServers
	microsip <--> SServers
	linphone <--> SServers
```

# 2. STATE 
## 2.1. CALL_STATE_INCOMING
```mermaid
flowchart LR
	ua_init --> sip_alloc --> sip_listen --> sipsess_listen --> sipevent_listen
		sip_alloc ..-> exit_handler
		sip_listen ..-> request_handler
		sipsess_listen ..-> sipsess_conn_handler
		sipevent_listen ..-> sub_handler
```
```mermaid
flowchart TD
	sipsess_conn_handler --> |1|ua_call_alloc --> call_alloc --> call_streams_alloc
		call_streams_alloc --> |1-2|video_alloc --> stream_alloc
			stream_alloc ..-> stream_recv_handler
			stream_alloc --> stream_sock_alloc --> rtp_listen ..-> rtp_handler
		call_streams_alloc --> |1-1|audio_alloc --> stream_alloc
	sipsess_conn_handler --> |2|call_accept --> |2-1|sdp_decode
		call_accept --> |2-2|sipsess_accept
			sipsess_accept ..-> auth_handler
			sipsess_accept ..-> sipsess_offer_handler
			sipsess_accept ..-> sipsess_answer_handler
			sipsess_accept ..-> sipsess_estab_handler
			sipsess_accept ..-> sipsess_info_handler
			sipsess_accept ..-> sipsess_refer_handler
			sipsess_accept ..-> sipsess_close_handler
		call_accept --> |2-3|set_state[set_state/CALL_STATE_INCOMING]
		call_accept --> |2-4, CALL_EVENT_INCOMING|call_event_handler
	sipsess_desc_handler ..-o call_streams_alloc
```

```mermaid
flowchart LR
	rtp_handler --o handle_rtp --> |rtph|stream_recv_handler
		stream_recv_handler --> video_stream_decode
		stream_recv_handler --> aurx_stream_decode
	rtp_handler --> |jbtype == JBUF_FIXED|stream_decode -->handle_rtp
	audio_decode --o stream_decode
```

## 2.2. CALL_STATE_ESTABLISHED

```mermaid
flowchart LR
	answer_call --> ua_answer --> call_answer --> update_media
		update_media --> |1|stream_update
		update_media --> |2|update_audio 
			update_audio --> |2-1|audio_decoder_set --> audio_start --> start_player --> auplay_alloc
			update_audio --> |2-2|audio_encoder_set --> audio_start
		update_media --> |3| video_update
			video_update --> |3-1|video_encoder_set
			video_update --> |3-2|video_decoder_set

```

```mermaid
flowchart LR

sipsess_estab_handler --> call_stream_start
	call_stream_start --> |1|start_audio
		start_audio --> |1-1|audio_decoder_set
		start_audio --> |1-2|audio_start
	call_stream_start --> |2|video_update
```

# 3. video

## 3.1. decode and encode

### 3.1.1. decode ( baresip --> output)

```mermaid
flowchart LR
	subgraph video_codec
		vc-encupdh[vc->encupdh]
		vc-ench[vc->ench]
		vc-decupdh[vc->decupdh]
		vc-dech[vc->dech]
		vc-fmtp_ench[v->fmtp_ench]
		vc-fmtp_cmph[vc->fmtp_cmph]
	end
	subgraph video_filter
		vf-encupdh[vf->encupdh]
		vf-ench[vf->ench]
		vf-decupdh[vf->decupdh]
		vf-dech[vf->dech]
	end
	subgraph video_display
		vd-alloch[vd->alloch]
		vd-updateh[vd->updateh]
		vd-disph[vd->disph]
		vd-hideh[vd->hideh]
	end
	subgraph video_stream_decode
		vidframe[(vidframe)]
	end
	subgraph stream_recv_handler
		mbuf[(mbuf)]
	end

	stream_recv_handler --> video_stream_decode
		video_stream_decode --> |1|vc-dech
		video_stream_decode --> |2|vf-dech
		video_stream_decode --> |3|vd-disph
	
```

### 3.1.2. encode ( source --> baresip)

```mermaid
flowchart LR
	subgraph video_codec
		direction LR
		vc-encupdh[vc->encupdh]
		subgraph vc-ench[vc->ench]
			mbuf[(mbuf)]
		end
		vc-decupdh[vc->decupdh]
		vc-dech[vc->dech]
		vc-fmtp_ench[vc->fmtp_ench]
		vc-fmtp_cmph[vc->fmtp_cmph]
		vc-packetizeh[vc->packetizeh]
	end
	subgraph video_filter
		direction LR
		vf-encupdh[vf->encupdh]
		vf-ench[vf->ench]
		vf-decupdh[vf->decupdh]
		vf-dech[vf->dech]
	end
	subgraph video_source
		direction LR
		vs-alloch[vs->alloch]
		vs-updateh[vs->updateh]
		vidframe[(vidframe)]
	end
	subgraph vidsrc_st
		vidsrc-frameh[vidsrc->frameh]
	end
	subgraph xxx_thread
		read_thread
	end
	subgraph list_append
		vtx-sendq[(vtx->sendq)]
	end
	subgraph stream_send
		tx-mb[(tx->mb)]
	end
	vs-alloch .-> xxx_thread --> vidsrc-frameh --> vidsrc_frame_handler
    vidsrc_frame_handler --> encode_rtp_send
		encode_rtp_send --> |1|vc-packetizeh
		encode_rtp_send --> |2|vf-ench
		encode_rtp_send --> |3|vc-ench --> packet_handler --> list_append
	
	vtx-sendq ..-> vidqueue_poll --> stream_send
```
## 3.2. video_codec

```mermaid
flowchart LR
	subgraph video_codec[vidcodec]
		vidcodec[vidcodec.c]

		av1[av1.c] --> vidcodec
		avcodec[avcodec.c] --> vidcodec
		gst_video[gst_video.c] --> vidcodec
		mock_vidcodec[mock_vidcodec.c / mock] --> vidcodec
		vp8[vp8.c] --> vidcodec
		vp9[vp9.c] --> vidcodec

	end
```

#### A. baresip.c

```c
# baresip.c
struct list *baresip_vidcodecl(void)
{
	return &baresip.vidcodecl;
}

# baresip.h
struct vidcodec {
	struct le le;
	const char *pt;
	const char *name;
	const char *variant;
	const char *fmtp;
	videnc_update_h *encupdh;
	videnc_encode_h *ench;
	viddec_update_h *decupdh;
	viddec_decode_h *dech;
	sdp_fmtp_enc_h *fmtp_ench;
	sdp_fmtp_cmp_h *fmtp_cmph;
	videnc_packetize_h *packetizeh;
};
```

#### B. vidcodec.c

```c
# vidcodec.c
void vidcodec_register(struct list *vidcodecl, struct vidcodec *vc)
```

#### C. video.c

```c
# video.c
# 422 - vc->ench
static void encode_rtp_send(struct vtx *vtx, struct vidframe *frame,
			    struct vidpacket *packet, uint64_t timestamp)
{
	...
	err = vtx->vc->ench(vtx->enc, vtx->picup, frame, timestamp);
	...
}

# 695 - vc->dech
static int video_stream_decode(struct vrx *vrx, const struct rtp_header *hdr,
			       struct mbuf *mb)
{
	...
	err = vrx->vc->dech(vrx->dec, frame, &intra, hdr->m, hdr->seq, mb);
	...
}

# 963 - vc->fmtp_ench, vc->fmtp_cmph
int video_alloc(struct video **vp, struct list *streaml,
		const struct stream_param *stream_prm,
		const struct config *cfg,
		struct sdp_session *sdp_sess,
		const struct mnat *mnat, struct mnat_sess *mnat_sess,
		const struct menc *menc, struct menc_sess *menc_sess,
		const char *content, const struct list *vidcodecl,
		const struct list *vidfiltl,
		bool offerer,
		video_err_h *errh, void *arg)
{
	...
		err |= sdp_format_add(NULL, stream_sdpmedia(v->strm), false,
				      vc->pt, vc->name, 90000, 1,
				      vc->fmtp_ench, vc->fmtp_cmph, vc, false,
				      "%s", vc->fmtp);
	...
}

# 1434 - vc->encupdh
int video_encoder_set(struct video *v, struct vidcodec *vc,
		      int pt_tx, const char *params)
{
	...
		err = vc->encupdh(&vtx->enc, vc, &prm, params,
	...
}

# 1483 - vc->decupdh
int video_decoder_set(struct video *v, struct vidcodec *vc, int pt_rx,
		      const char *fmtp)
{
	...
		err = vc->decupdh(&vrx->dec, vc, fmtp);
	...
}
```

## 3.3. video_filter
```mermaid
flowchart LR
	subgraph video_filter[video_filter]
		vidfilt[vidfilt.c]

		avfilter[avfilter.c] --> vidfilt
		selfview[selfview.c] --> vidfilt
		snapshot[snapshot.c] --> vidfilt
		swscale[swscale.c] --> vidfilt
		vidinfo[vidinfo.c] --> vidfilt

	end
```
#### A. baresip.c

```c
# baresip.c
struct list *baresip_vidfiltl(void)
{
	return &baresip.vidfiltl;
}

# baresip.h
struct vidfilt {
	struct le le;
	const char *name;
	vidfilt_encupd_h *encupdh;
	vidfilt_encode_h *ench;
	vidfilt_decupd_h *decupdh;
	vidfilt_decode_h *dech;
};
```

#### B. vidfilt.c

```c
# vidfilt.c
# 17
void vidfilt_register(struct list *vidfiltl, struct vidfilt *vf)

# 61 - vf->encupdh
int vidfilt_enc_append(struct list *filtl, void **ctx,
		       const struct vidfilt *vf, struct vidfilt_prm *prm,
		       const struct video *vid)
{
	...
		err = vf->encupdh(&st, ctx, vf, prm, vid);
	...
}

# 105 - vf->decupdh
int vidfilt_dec_append(struct list *filtl, void **ctx,
		       const struct vidfilt *vf, struct vidfilt_prm *prm,
		       const struct video *vid)
{
	...
		err = vf->decupdh(&st, ctx, vf, prm, vid);
	...
}
```

#### C. video.c

```c
# video.c
# 422 - vf->ench
static void encode_rtp_send(struct vtx *vtx, struct vidframe *frame,
			    struct vidpacket *packet, uint64_t timestamp)
{
	...
			err |= st->vf->ench(st, frame, &timestamp);
	...
}

# 695 - vf->dech
static int video_stream_decode(struct vrx *vrx, const struct rtp_header *hdr,
			       struct mbuf *mb)
{
	...
			err |= st->vf->dech(st, frame, &timestamp);
	...
}

# 886 - vf->ench
static int vtx_print_pipeline(struct re_printf *pf, const struct vtx *vtx)
{
	...
		if (st->vf->ench)
			err |= re_hprintf(pf, " ---> %s", st->vf->name);
	...
}

# 963
int video_alloc(struct video **vp, struct list *streaml,
		const struct stream_param *stream_prm,
		const struct config *cfg,
		struct sdp_session *sdp_sess,
		const struct mnat *mnat, struct mnat_sess *mnat_sess,
		const struct menc *menc, struct menc_sess *menc_sess,
		const char *content, const struct list *vidcodecl,
		const struct list *vidfiltl,
		bool offerer,
		video_err_h *errh, void *arg)
{
	...
		err |= vidfilt_enc_append(&v->vtx.filtl, &ctx, vf, &prmenc, v);
		err |= vidfilt_dec_append(&v->vrx.filtl, &ctx, vf, &prmdec, v);
	...
}
```

## 3.4. video_display
```mermaid
flowchart LR
	subgraph video_source[video_source]
		vidisp[vidisp.c]

		vidisp --> directfb[directfb.c]
		vidisp --> fakevideo[fakevideo.c]
		vidisp --> mock_vidisp[mock_vidisp.c]
		vidisp --> module[module.c/mock]
		vidisp --> sdl[sdl.c]
		vidisp --> vidbridge[vidbridge.c]
		vidisp --> x11[x11.c]

	end
```


#### A. baresip.c

```c
# baresip.c
struct list *baresip_vidispl(void)
{
	return &baresip.vidispl;
}

# baresip.h
/** Defines a Video display */
struct vidisp {
	struct le        le;
	const char      *name;
	vidisp_alloc_h  *alloch;
	vidisp_update_h *updateh;
	vidisp_disp_h   *disph;
	vidisp_hide_h   *hideh;
};
```

#### B. vidisp.c

```c
# vidisp.c
# 31
int vidisp_register(struct vidisp **vp, struct list *vidispl, const char *name, vidisp_alloc_h *alloch, vidisp_update_h *updateh, vidisp_disp_h *disph, vidisp_hide_h *hideh)

# 91
int vidisp_alloc(struct vidisp_st **stp, struct list *vidispl,
		 const char *name,
		 struct vidisp_prm *prm, const char *dev,
		 vidisp_resize_h *resizeh, void *arg)
{
	struct vidisp *vd = (struct vidisp *)vidisp_find(vidispl, name);
	if (!vd)
		return ENOENT;

	return vd->alloch(stp, vd, prm, dev, resizeh, arg);
}
```

#### C. video.c

```c
# video.c
# 695 - vd->disph
static int video_stream_decode(struct vrx *vrx, const struct rtp_header *hdr,
			       struct mbuf *mb)
{
	...
		err = vrx->vd->disph(vrx->vidisp, v->peer, frame, timestamp);
	...
}

# 1090 - vd->alloch
static int set_vidisp(struct vrx *vrx)
{
	...
	err = vd->alloch(&vrx->vidisp, vd, &vrx->vidisp_prm, vrx->device,
			 vidisp_resize_handler, vrx);
	...
}

# 1299 - set_vidisp
int video_start_display(struct video *v, const char *peer)
{
	...
	if (vidisp_find(baresip_vidispl(), NULL)) {
		err = set_vidisp(&v->vrx);
		...
	}
	...
}

# 1382 - vd->updateh
static int vidisp_update(struct vrx *vrx)
{
	...
		err = vd->updateh(vrx->vidisp, vrx->vidisp_prm.fullscreen,
				  vrx->orient, NULL);
	...
}
```

## 3.5. video_source

```mermaid
flowchart LR
	subgraph video_source[video_source]
		vidsrc[vidsrc.c]

		avcapture[avcapture.m] --> vidsrc
		avformat[avformat.c] --> vidsrc
		dshow[dshow.cpp] --> vidsrc
		fakevideo[fakevideo.c] --> vidsrc
		v4l2[v4l2.c] --> vidsrc
		vidbridge[vidbridge.c] --> vidsrc
		x11grab[x11grab.c] --> vidsrc

	end
```

#### A. baresip.c

```c
# baresip.c
struct list *baresip_vidsrcl(void)
{
	return &baresip.vidsrcl;
}

# baresip.h
/** Defines a video source */
struct vidsrc {
	struct le         le;
	const char       *name;
	struct list      dev_list;
	vidsrc_alloc_h   *alloch;
	vidsrc_update_h  *updateh;
};

```

#### B. vidsrc.c

```c
# vidsrc.c
int vidsrc_register(struct vidsrc **vsp, struct list *vidsrcl,
		    const char *name,
		    vidsrc_alloc_h *alloch, vidsrc_update_h *updateh)

# 103 - vs->alloch
int vidsrc_alloc(struct vidsrc_st **stp, struct list *vidsrcl,
		 const char *name,
		 struct vidsrc_prm *prm,
		 const struct vidsz *size, const char *fmt, const char *dev,
		 vidsrc_frame_h *frameh, vidsrc_packet_h *packeth,
		 vidsrc_error_h *errorh, void *arg)
{
	...
	return vs->alloch(stp, vs, prm, size, fmt, dev,
			  frameh, packeth, errorh, arg);
}
```

#### C. video.c

```c
# video.c
# 1226
int video_start_source(struct video *v)
{
	...
		err = vs->alloch(&vtx->vsrc, vs, &vtx->vsrc_prm,
				 &vtx->vsrc_size, NULL, v->vtx.device,
				 vidsrc_frame_handler, vidsrc_packet_handler,
				 vidsrc_error_handler, vtx);
	...
}

# 1413
static void vidsrc_update(struct vtx *vtx, const char *dev)
{
	...
		vs->updateh(vtx->vsrc, &vtx->vsrc_prm, dev);
	...
}

# 1694
int video_set_source(struct video *v, const char *name, const char *dev)
{
	...
	err = vs->alloch(&vtx->vsrc, vs, &vtx->vsrc_prm,
			 &vtx->vsrc_size, NULL, dev,
			 vidsrc_frame_handler, vidsrc_packet_handler,
			 vidsrc_error_handler, vtx);
	...
}
```

# 4. audio

## 4.1. decode and encode

### 4.1.1. decode (baresip -> output)

```mermaid
flowchart LR
	subgraph audio_codec
		direction LR
		ac-decupdh[ac->decupdh]
		ac-dech[ac->dech]
		ac-plch[ac->plch]
	end
	subgraph audio_filter
		direction LR
		af-decupdh[af->decupdh]
		af-dech[af->dech]
	end
	subgraph audio_play
		ap-alloch[ap->alloch]
	end
	rx-aubuf[(rx->aubuf)]
	subgraph aubuf_read
		af-sampv[(af->sampv)]
	end
	rx-aubuf[(rx->aubuf)] .-> af-sampv
	stream_recv_handler --> aurx_stream_decode
		aurx_stream_decode --> |1|ac-dech
		aurx_stream_decode --> |2|af-dech
		aurx_stream_decode --> |3|aubuf_write --> rx-aubuf
	audio_start --> start_player --> auplay_alloc --> ap-alloch .-> write_thread --> auplay_write_handler --> aubuf_read
```

### 4.1.2. encode ( source --> baresip)

```mermaid
flowchart LR
	subgraph video_codec
		direction LR
		vc-encupdh[ac->encupdh]
		vc-ench[ac->ench]
		vc-decupdh[ac->decupdh]
		vc-dech[ac->dech]
		vc-fmtp_ench[ac->fmtp_ench]
		vc-fmtp_cmph[ac->fmtp_cmph]
	end
	subgraph audio_filter
		direction LR
		af-encupdh[af->encupdh]
		af-ench[af->ench]
		af-decupdh[af->decupdh]
		af-dech[af->dech]
	end
	subgraph audio_source
		direction LR
		as-alloch[as->alloch]
	end
	subgraph xxx_thread[play_thread/read_thread]
		af-sampv[(af->sampv)]
	end
	subgraph stream_send
		tx-mb[(tx->mb)]
	end
	ausrc_alloc --> as-alloch .-> xxx_thread

	xxx_thread --> ausrc_read_handler --> poll_aubuf_tx 
	poll_aubuf_tx --> |1|af-ench
	poll_aubuf_tx --> |2|encode_rtp_send
	encode_rtp_send -->|2-1|vc-ench
		vc-ench .-> tx-mb
	encode_rtp_send -->|2-2|stream_send --> rtp_send

```

## 4.2. audio_codec
```mermaid
flowchart LR
	subgraph audio_codec[audio_codec]
		aucodec[aucodec.c]

		aac[aac.c] --> aucodec
		amr[amr.c] --> aucodec
		aptx[aptx.c] --> aucodec
		codec2[codec2.c] --> aucodec
		g711[g711.c] --> aucodec
		g722[g722.c] --> aucodec
		g7221[g7221.c] --> aucodec
		g726[g726.c] --> aucodec
		gsm[gsm.c] --> aucodec
		l16[l16.c] --> aucodec
		mpa[mpa.c] --> aucodec
		opus[opus.c] --> aucodec
		opus_multistream[opus_multistream.c] --> aucodec

	end
```

#### A. baresip.c

```c
# baresip.c
struct list *baresip_aucodecl(void)
{
	return &baresip.aucodecl;
}

# baresip.h
struct aucodec {
	struct le le;
	const char *pt;
	const char *name;
	uint32_t srate;             /* Audio samplerate */
	uint32_t crate;             /* RTP Clock rate   */
	uint8_t ch;
	uint8_t pch;                /* RTP packet channels */
	uint32_t ptime;             /* Packet time in [ms] (optional) */
	const char *fmtp;
	auenc_update_h *encupdh;
	auenc_encode_h *ench;
	audec_update_h *decupdh;
	audec_decode_h *dech;
	audec_plc_h    *plch;
	sdp_fmtp_enc_h *fmtp_ench;
	sdp_fmtp_cmp_h *fmtp_cmph;
};
```

#### B. aucodec.c

```c
# aucodec.c
void aucodec_register(struct list *aucodecl, struct aucodec *ac)
```
#### C. audio.c

```c
# audio.c
# 406 - ac->fmtp_ench, ac->fmtp_cmph
static int add_audio_codec(struct sdp_media *m, struct aucodec *ac)
{
	...
	return sdp_format_add(NULL, m, false, ac->pt, ac->name, ac->crate,
			      ac->pch, ac->fmtp_ench, ac->fmtp_cmph, ac, false,
			      "%s", ac->fmtp);
}

# 453 - ac->ench
static void encode_rtp_send(struct audio *a, struct autx *tx,
			    int16_t *sampv, size_t sampc, enum aufmt fmt)
{
	...
  err = tx->ac->ench(tx->enc, &marker, mbuf_buf(tx->mb), &len,
			   fmt, sampv, sampc);
	...
}

# 1005 - ac->dech
static int aurx_stream_decode(struct aurx *rx, bool marker,
			      struct mbuf *mb, unsigned lostc)
{
	...
	if (lostc && rx->ac->plch) {

		err = rx->ac->plch(rx->dec,
				   rx->dec_fmt, rx->sampv, &sampc,
				   mbuf_buf(mb), mbuf_get_left(mb));
	...
 	else if (mbuf_get_left(mb)) {

    err = rx->ac->dech(rx->dec,
				   rx->dec_fmt, rx->sampv, &sampc,
				   marker, mbuf_buf(mb), mbuf_get_left(mb));
	...
}

# 2017 - ac->encupdh
int audio_encoder_set(struct audio *a, const struct aucodec *ac,
		      int pt_tx, const char *params)
{
	...
		err = ac->encupdh(&tx->enc, ac, &prm, params);
	...
}

# 2091 - ac->decupdh
int audio_decoder_set(struct audio *a, const struct aucodec *ac,
		      int pt_rx, const char *params)
{
	...
		err = ac->decupdh(&rx->dec, ac, params);
	...
}

# 2577 - ac->encupdh
int audio_set_bitrate(struct audio *au, uint32_t bitrate)
{
	...
			err = ac->encupdh(&tx->enc, ac, &prm, NULL);
	...
}
```

## 4.3. audio_filter
```mermaid
flowchart LR
	subgraph audio_filter[audio_filter]
		aufilt[aufilt.c]

		aec[aec.cpp] --> aufilt
		auconv[auconv.c] --> aufilt
		gtk_mod[gtk_mod.c] --> aufilt
		mixausrc[mixausrc.c] --> aufilt
		mixminus[mixminus.c] --> aufilt
		mock_aufilt[mock_aufilt.c / mock] --> aufilt
		plc[plc.c] --> aufilt
		sndfile[sndfile.c] --> aufilt
		spksink[spksink.c] --> aufilt
		vumeter[vumeter.c] --> aufilt

	end
```
#### A. baresip.c

```c
# baresip.c
struct list *baresip_aufiltl(void)
{
	return &baresip.aufiltl;
}

# baresip.h
struct aufilt {
	struct le le;
	const char *name;
	aufilt_encupd_h *encupdh;
	aufilt_encode_h *ench;
	aufilt_decupd_h *decupdh;
	aufilt_decode_h *dech;
};
```

#### B. aufilt.c

```c
# aufilt.c
void aufilt_register(struct list *aufiltl, struct aufilt *af)
```

#### C. audio.c

```c
# audio.c
# 563 - af->ench
static void poll_aubuf_tx(struct audio *a)
{
	...
			err |= st->af->ench(st, &af);
	...
}

# 1535 - af->ench
static int autx_print_pipeline(struct re_printf *pf, const struct autx *autx)
{
	...
		if (st->af->ench)
			err |= re_hprintf(pf, " ---> %s", st->af->name);
	...
}

# 1560 - af->dech
static int aurx_print_pipeline(struct re_printf *pf, const struct aurx *aurx)
{
	...
		if (st->af->dech)
			err |= re_hprintf(pf, " <--- %s", st->af->name);
	...
}

# 1594 - af->encupdh
static int aufilt_setup(struct audio *a, struct list *aufiltl)
{
	...
			err = af->encupdh(&encst, &ctx, af, &encprm, a);
	...
			err = af->decupdh(&decst, &ctx, af, &decprm, a);
	...
}

static int aurx_stream_decode(struct aurx *rx, bool marker, struct mbuf *mb, unsigned lostc)
{
	...
		if (st->af && st->af->dech)
			err |= st->af->dech(st, &af);
	...
}
```

## 4.4. audio_play

```mermaid
flowchart LR
	subgraph audio_filter[audio_filter]
		auplay[auplay.c]

		alsa[alsc.c] --> auplay
		aubridge[aubridge.c] --> auplay
		audiounit[audiounit.c] --> auplay
		aufile[aufile.c] --> auplay
		coreaudio[coreaudio.c] --> auplay
		gstx[gstx.c] --> auplay
		i2s[i2s.c] --> auplay
		jack[jack.c] --> auplay
		mock_auplay[mock_auplay.c / mock] --> auplay
		portaudio[portaudio.c] --> auplay
		pulse[pulse.c] --> auplay
		sndio[snd.c] --> auplay
		winwave[winwave.c] --> auplay

	end
```

#### A. baresip.c

```c
# baresip.c
struct list *baresip_auplayl(void)
{
	return &baresip.auplayl;
}

# baresip.h
/** Defines an Audio Player */
struct auplay {
	struct le        le;
	const char      *name;
	struct list      dev_list;
	auplay_alloc_h  *alloch;
};
```

#### B. auplay.c

```c
# auplay.c
int auplay_register(struct auplay **app, struct list *auplayl, const char *name, auplay_alloc_h *alloch)

# 99 - ap->alloch
int auplay_alloc(struct auplay_st **stp, struct list *auplayl,
		 const char *name,
		 struct auplay_prm *prm, const char *device,
		 auplay_write_h *wh, void *arg)
{
	...
	return ap->alloch(stp, ap, prm, device, wh, arg);
}
```

#### C. audio.c

```c
# audio.c
# 716 - 
static void auplay_write_handler(struct auframe *af, void *arg)
{
	...
	aubuf_read(rx->aubuf, af->sampv, num_bytes);
	...
}

# 1660
static int start_player(struct aurx *rx, struct audio *a,
			struct list *auplayl)
{
	...
		err = auplay_alloc(&rx->auplay, auplayl,
				   rx->module,
				   &prm, rx->device,
				   rx->jbtype == JBUF_ADAPTIVE ?
				   auplay_write_handler2 :
				   auplay_write_handler, a);
	...
}

# 1896
int audio_start(struct audio *a)
{
	...
	err  = start_player(&a->rx, a, baresip_auplayl());
	err |= start_source(&a->tx, a, baresip_ausrcl());
	...
}

# 2534
int audio_set_player(struct audio *a, const char *mod, const char *device)
{
	...
		err = auplay_alloc(&rx->auplay, baresip_auplayl(),
				   mod, &rx->auplay_prm, device,
				   rx->jbtype == JBUF_ADAPTIVE ?
				   auplay_write_handler2 :
				   auplay_write_handler, a);
	...
}
```

## 4.5. audio_source

```mermaid
flowchart LR
	subgraph audio_source[audio_source]
		ausrc[ausrc.c]

		alsa[alsa.c] --> ausrc
		aubridge[aubridge.c] --> ausrc
		audiounit[audiounit.c] --> ausrc
		aufile[aufile.c] --> ausrc
		ausine[ausine.c] --> ausrc
		avformat[avformat.c] --> ausrc
		coreaudio[coreaudio.c] --> ausrc
		gst[gst.c] --> ausrc
		i2s[i2s.c] --> ausrc
		jack[jack.c] --> ausrc
		opensles[opensles.c] --> ausrc
		portaudio[portaudio.c] --> ausrc
		pulse[pulse.c] --> ausrc
		sndio[sndio.c] --> ausrc
		winwave[winwave.c] --> ausrc

	end
```

#### A. baresip.c

```c
# baresip.c
struct list *baresip_ausrcl(void)
{
	return &baresip.ausrcl;
}

# baresip.h
/** Defines an Audio Source */
struct ausrc {
	struct le        le;
	const char      *name;
	struct list      dev_list;
	ausrc_alloc_h   *alloch;
};
```

#### B. ausrc.c

```c
# ausrc.c
int ausrc_register(struct ausrc **asp, struct list *ausrcl, const char *name, ausrc_alloc_h *alloch)

# 97 - as->alloch
int ausrc_alloc(struct ausrc_st **stp, struct list *ausrcl,
		const char *name, struct ausrc_prm *prm, const char *device,
		ausrc_read_h *rh, ausrc_error_h *errh, void *arg)
{
	struct ausrc *as;

	as = (struct ausrc *)ausrc_find(ausrcl, name);
	if (!as)
		return ENOENT;

	return as->alloch(stp, as, prm, device, rh, errh, arg);
}
```

#### C. audio.c

```c
# audio.c
# 1896
int audio_start(struct audio *a)
{
	...
	err  = start_player(&a->rx, a, baresip_auplayl());
	err |= start_source(&a->tx, a, baresip_ausrcl());
	...
}

# 2493
int audio_set_source(struct audio *au, const char *mod, const char *device)
{
	...
		err = ausrc_alloc(&tx->ausrc, baresip_ausrcl(),
				  mod, &tx->ausrc_prm, device,
				  ausrc_read_handler, ausrc_error_handler, au);
	...
}
```

# 5. modules

> baresip 使用 plugin 的方式相當的淋漓盡致，這部分還有待學習。

## 5.1. stdio.so

> 從 STDIN_FILENO 等待按鍵按下；當按鍵觸發後的流程，大致如下。另外常用傳送命令的 cons.so (Console input driver) 和 ctrl_dbus.so (DBus control interface)

> 這邊要注意 stdio 和 cons 有處理 KEYCODE_REL

```mermaid
flowchart LR
	subgraph cmd[cmd.c]
		cmd_process
		cmd_process_long
	end

	subgraph ui[ui.c]
		ui_input_key
		ui_input_long_command
	end
	ui_input_key --> cmd_process
	ui_input_long_command --> cmd_process_long

	subgraph stdio[stdio.c]
		ui_fd_handler
		report_key
		stdio-timeout[timeout]
		
		ui_fd_handler-->report_key
		ui_fd_handler ..-> |250ms, KEYCODE_REL|stdio-timeout --> report_key
	end
	STDIN_FILENO ..-> ui_fd_handler
	report_key --> ui_input_key

	subgraph cons[cons.c]
		udp_recv
		cons-timeout[timeout]
	end
	udp_recv --> ui_input_key
	cons-timeout --> ui_input_key

	subgraph ctrl_dbus[ctrl_dbus.c]
		command_handler
	end
	command_handler --> cmd_process
	command_handler --> cmd_process_long
```

# 6. Others

## 6.1. parse usage

> src/[main.c](https://github.com/baresip/baresip/blob/main/src/main.c)
> 參數的進入點
>
> |      | Help             | Variables                        |
> | ---- | ---------------- | -------------------------------- |
> | -f   | Config path      | conf_path_set(optarg);           |
> | -s   | Enable SIP trace | sip_trace = true;<br>sip->traceh |
> | -v   | Verbose debug    | log_enable_debug(true);          |

```bash
static void usage(void)
{
	(void)re_fprintf(stderr,
			 "Usage: baresip [options]\n"
			 "options:\n"
			 "\t-4               Force IPv4 only\n"
#if HAVE_INET6
			 "\t-6               Force IPv6 only\n"
#endif
			 "\t-a <software>    Specify SIP User-Agent string\n"
			 "\t-d               Daemon\n"
			 "\t-e <commands>    Execute commands (repeat)\n"
			 "\t-f <path>        Config path\n"
			 "\t-m <module>      Pre-load modules (repeat)\n"
			 "\t-p <path>        Audio files\n"
			 "\t-h -?            Help\n"
			 "\t-s               Enable SIP trace\n"
			 "\t-t <sec>         Quit after <sec> seconds\n"
			 "\t-n <net_if>      Specify network interface\n"
			 "\t-u <parameters>  Extra UA parameters\n"
			 "\t-v               Verbose debug\n"
			 );
}
```

## 6.2. mb Memory buffer

> github: [re](https://github.com/baresip/re/tree/main)/[include](https://github.com/baresip/re/tree/main/include)/[re_mbuf.h](https://github.com/baresip/re/blob/main/include/re_mbuf.h)

### 6.2.1. Get the buffer from the current position

```c
/**
 * Get the buffer from the current position
 *
 * @param mb Memory buffer
 *
 * @return Current buffer
 */
static inline uint8_t *mbuf_buf(const struct mbuf *mb)
```

```c
// Current buffer
char *buf = mbuf_buf(msg->mb);
```

## 6.3. SIP headers

### 6.3.1. custom SIP headers (Send)

```mermaid
flowchart LR
	subgraph phone[phone]
	end

	subgraph baresip[baresip]

	end

	baresip --> |custom SIP headers| phone
```

#### A. Get the list of custom SIP headers

> github: [baresip](https://github.com/baresip/baresip/tree/main)/[src](https://github.com/baresip/baresip/tree/main/src)/[call.c](https://github.com/baresip/baresip/blob/main/src/call.c)

```c
/**
 * Get the list of custom SIP headers
 *
 * @param call Call object
 *
 * @return List of custom SIP headers (struct sip_hdr)
 */
const struct list *call_get_custom_hdrs(const struct call *call)
{
	if (!call)
		return NULL;

	return &call->custom_hdrs;
}
```

```c
const struct list *hdrs = call_get_custom_hdrs(call);
```

#### B. Add a custom SIP header to the list

> github: [baresip](https://github.com/baresip/baresip/tree/main)/[src](https://github.com/baresip/baresip/tree/main/src)/[custom_hdrs.c](https://github.com/baresip/baresip/blob/main/src/custom_hdrs.c)
>
> 在 header 新增
>
> User: lanka

```c
# baresip/src/custom_hdrs.c
/**
 * Add a custom SIP header to the list
 *
 * @param hdrs List of custom headers
 * @param name Header name
 * @param fmt  Formatted header value
 * @param ...  Variable arguments
 *
 * @return 0 if success, otherwise errorcode
 */
int custom_hdrs_add(struct list *hdrs, const char *name, const char *fmt, ...)
```

```c
if ( 0 != custom_hdrs_add((struct list *)hdrs, "User", "lanka") )
{
	RDBG_WN_LN("custom_hdrs_add error !!! (User: %s)", "lanka");
}
```

### 6.3.1. SIP Headers (Receive)

```mermaid
flowchart LR
	subgraph phone[phone]
	end

	subgraph baresip[baresip]

	end

	phone --> |headers| baresip
```

| NAME                | FUNCTION               |      |
| ------------------- | ---------------------- | ---- |
| SIP/2.0 100 Trying  | sipsess_progr_handler  |      |
| SIP/2.0 180 Ringing | sipsess_progr_handler  |      |
| SIP/2.0 200 OK      | sipsess_answer_handler |      |
|                     | sipsess_estab_handler  |      |
| INVITE sip:         | call_accept            |      |
|                     |                        |      |

#### A. Print a SIP Message to stdout

> github: [re](https://github.com/baresip/re/tree/main)/[src](https://github.com/baresip/re/tree/main/src)/[sdp](https://github.com/baresip/re/tree/main/src/sdp)/[msg.c](https://github.com/baresip/re/blob/main/src/sdp/msg.c)

```c
/**
 * Print a SIP Message to stdout
 *
 * @param msg SIP Message
 */
void sip_msg_dump(const struct sip_msg *msg)
```

```c
sip_msg_dump(msg);
```

```log
05 'Contact'='<sip:1007@192.168.50.9:5060>'
09 'To'='<sip:1007@192.168.50.9;transport=udp>;tag=as29ce46d9'
09 'Content-Type'='application/sdp'
10 'CSeq'='4843 INVITE'
11 'From'='<sip:1004@192.168.50.9>;tag=fa43ee5ffd74be1d'
13 'Server'='Asterisk PBX 16.2.1~dfsg-2ubuntu1'
21 'Content-Length'='382'
23 'Call-ID'='e348a6c46245303d'
23 'Supported'='replaces'
23 'Supported'='timer'
25 'Via'='SIP/2.0/UDP 192.168.50.72:38063;branch=z9hG4bK02f5b79400a89be7;received=192.168.50.72;rport=38063'
29 'Allow'='INVITE'
29 'Allow'='ACK'
29 'Allow'='CANCEL'
29 'Allow'='OPTIONS'
29 'Allow'='BYE'
29 'Allow'='REFER'
29 'Allow'='SUBSCRIBE'
29 'Allow'='NOTIFY'
29 'Allow'='INFO'
29 'Allow'='PUBLISH'
29 'Allow'='MESSAGE'
3961 'Via'='SIP/2.0/UDP 192.168.50.72:38063;branch=z9hG4bK02f5b79400a89be7;received=192.168.50.72;rport=38063'
1963 'From'='<sip:1004@192.168.50.9>;tag=fa43ee5ffd74be1d'
1449 'To'='<sip:1007@192.168.50.9;transport=udp>;tag=as29ce46d9'
3095 'Call-ID'='e348a6c46245303d'
746 'CSeq'='4843 INVITE'
973 'Server'='Asterisk PBX 16.2.1~dfsg-2ubuntu1'
2429 'Allow'='INVITE, ACK, CANCEL, OPTIONS, BYE, REFER, SUBSCRIBE, NOTIFY, INFO, PUBLISH, MESSAGE'
119 'Supported'='replaces, timer'
229 'Contact'='<sip:1007@192.168.50.9:5060>'
809 'Content-Type'='application/sdp'
3861 'Content-Length'='382'
```

#### B. Get a SIP Header from a SIP Message

> github: [re](https://github.com/baresip/re/tree/main)/[src](https://github.com/baresip/re/tree/main/src)/[sdp](https://github.com/baresip/re/tree/main/src/sdp)/[msg.c](https://github.com/baresip/re/blob/main/src/sdp/msg.c)

```c
/**
 * Get a SIP Header from a SIP Message
 *
 * @param msg SIP Message
 * @param id  SIP Header ID
 *
 * @return SIP Header if found, NULL if not found
 */
const struct sip_hdr *sip_msg_hdr(const struct sip_msg *msg, enum sip_hdrid id)
```

#### C. SIP Header ID (perfect hash value)

> github: [re](https://github.com/baresip/re/tree/main)/[include](https://github.com/baresip/re/tree/main/include)/[re_sip.h](https://github.com/baresip/re/blob/main/include/re_sip.h)

```c
/** SIP Header ID (perfect hash value) */
enum sip_hdrid {
	SIP_HDR_ACCEPT                        = 3186,
	SIP_HDR_ACCEPT_CONTACT                =  232,
	SIP_HDR_ACCEPT_ENCODING               =  708,
	SIP_HDR_ACCEPT_LANGUAGE               = 2867,
	SIP_HDR_ACCEPT_RESOURCE_PRIORITY      = 1848,
	SIP_HDR_ALERT_INFO                    =  274,
	SIP_HDR_ALLOW                         = 2429,
	SIP_HDR_ALLOW_EVENTS                  =   66,
	SIP_HDR_ANSWER_MODE                   = 2905,
	SIP_HDR_AUTHENTICATION_INFO           = 3144,
	SIP_HDR_AUTHORIZATION                 = 2503,
	SIP_HDR_CALL_ID                       = 3095,
	SIP_HDR_CALL_INFO                     =  586,
	SIP_HDR_CONTACT                       =  229,
	SIP_HDR_CONTENT_DISPOSITION           = 1425,
	SIP_HDR_CONTENT_ENCODING              =  580,
	SIP_HDR_CONTENT_LANGUAGE              = 3371,
	SIP_HDR_CONTENT_LENGTH                = 3861,
	SIP_HDR_CONTENT_TYPE                  =  809,
	SIP_HDR_CSEQ                          =  746,
	SIP_HDR_DATE                          = 1027,
	SIP_HDR_ENCRYPTION                    = 3125,
	SIP_HDR_ERROR_INFO                    =   21,
	SIP_HDR_EVENT                         = 3286,
	SIP_HDR_EXPIRES                       = 1983,
	SIP_HDR_FLOW_TIMER                    =  584,
	SIP_HDR_FROM                          = 1963,
	SIP_HDR_HIDE                          =  283,
	SIP_HDR_HISTORY_INFO                  = 2582,
	SIP_HDR_IDENTITY                      = 2362,
	SIP_HDR_IDENTITY_INFO                 =  980,
	SIP_HDR_IN_REPLY_TO                   = 1577,
	SIP_HDR_JOIN                          = 3479,
	SIP_HDR_MAX_BREADTH                   = 3701,
	SIP_HDR_MAX_FORWARDS                  = 3549,
	SIP_HDR_MIME_VERSION                  = 3659,
	SIP_HDR_MIN_EXPIRES                   = 1121,
	SIP_HDR_MIN_SE                        = 2847,
	SIP_HDR_ORGANIZATION                  = 3247,
	SIP_HDR_P_ACCESS_NETWORK_INFO         = 1662,
	SIP_HDR_P_ANSWER_STATE                =   42,
	SIP_HDR_P_ASSERTED_IDENTITY           = 1233,
	SIP_HDR_P_ASSOCIATED_URI              =  900,
	SIP_HDR_P_CALLED_PARTY_ID             = 3347,
	SIP_HDR_P_CHARGING_FUNCTION_ADDRESSES = 2171,
	SIP_HDR_P_CHARGING_VECTOR             =   25,
	SIP_HDR_P_DCS_TRACE_PARTY_ID          = 3027,
	SIP_HDR_P_DCS_OSPS                    = 1788,
	SIP_HDR_P_DCS_BILLING_INFO            = 2017,
	SIP_HDR_P_DCS_LAES                    =  693,
	SIP_HDR_P_DCS_REDIRECT                = 1872,
	SIP_HDR_P_EARLY_MEDIA                 = 2622,
	SIP_HDR_P_MEDIA_AUTHORIZATION         = 1035,
	SIP_HDR_P_PREFERRED_IDENTITY          = 1263,
	SIP_HDR_P_PROFILE_KEY                 = 1904,
	SIP_HDR_P_REFUSED_URI_LIST            = 1047,
	SIP_HDR_P_SERVED_USER                 = 1588,
	SIP_HDR_P_USER_DATABASE               = 2827,
	SIP_HDR_P_VISITED_NETWORK_ID          = 3867,
	SIP_HDR_PATH                          = 2741,
	SIP_HDR_PERMISSION_MISSING            = 1409,
	SIP_HDR_PRIORITY                      = 3520,
	SIP_HDR_PRIV_ANSWER_MODE              = 2476,
	SIP_HDR_PRIVACY                       = 3150,
	SIP_HDR_PROXY_AUTHENTICATE            =  116,
	SIP_HDR_PROXY_AUTHORIZATION           = 2363,
	SIP_HDR_PROXY_REQUIRE                 = 3562,
	SIP_HDR_RACK                          = 2523,
	SIP_HDR_REASON                        = 3732,
	SIP_HDR_RECORD_ROUTE                  =  278,
	SIP_HDR_REFER_SUB                     = 2458,
	SIP_HDR_REFER_TO                      = 1521,
	SIP_HDR_REFERRED_BY                   = 3456,
	SIP_HDR_REJECT_CONTACT                =  285,
	SIP_HDR_REPLACES                      = 2534,
	SIP_HDR_REPLY_TO                      = 2404,
	SIP_HDR_REQUEST_DISPOSITION           = 3715,
	SIP_HDR_REQUIRE                       = 3905,
	SIP_HDR_RESOURCE_PRIORITY             = 1643,
	SIP_HDR_RESPONSE_KEY                  = 1548,
	SIP_HDR_RETRY_AFTER                   =  409,
	SIP_HDR_ROUTE                         =  661,
	SIP_HDR_RSEQ                          =  445,
	SIP_HDR_SECURITY_CLIENT               = 1358,
	SIP_HDR_SECURITY_SERVER               =  811,
	SIP_HDR_SECURITY_VERIFY               =  519,
	SIP_HDR_SERVER                        =  973,
	SIP_HDR_SERVICE_ROUTE                 = 1655,
	SIP_HDR_SESSION_EXPIRES               = 1979,
	SIP_HDR_SIP_ETAG                      = 1997,
	SIP_HDR_SIP_IF_MATCH                  = 3056,
	SIP_HDR_SUBJECT                       = 1043,
	SIP_HDR_SUBSCRIPTION_STATE            = 2884,
	SIP_HDR_SUPPORTED                     =  119,
	SIP_HDR_TARGET_DIALOG                 = 3450,
	SIP_HDR_TIMESTAMP                     =  938,
	SIP_HDR_TO                            = 1449,
	SIP_HDR_TRIGGER_CONSENT               = 3180,
	SIP_HDR_UNSUPPORTED                   =  982,
	SIP_HDR_USER_AGENT                    = 4064,
	SIP_HDR_VIA                           = 3961,
	SIP_HDR_WARNING                       = 2108,
	SIP_HDR_WWW_AUTHENTICATE              = 2763,

	SIP_HDR_NONE = -1
};
```

```c
const struct sip_hdr *type_hdr = sip_msg_hdr(msg, SIP_HDR_CONTENT_TYPE);
if (!type_hdr)
{
	RDBG_WN_LN("(Content-Type: %r)", &type_hdr->val);
}
```

```log
sipsess_estab_handler:1717 - (Content-Type: application/sdp)
```

## 6.4. SDP

> github: [re](https://github.com/baresip/re/tree/main)/[src](https://github.com/baresip/re/tree/main/src)/[sdp](https://github.com/baresip/re/tree/main/src/sdp)/[msg.c](https://github.com/baresip/re/blob/main/src/sdp/msg.c)

```c
/**
 * Encode an SDP Session into a memory buffer
 *
 * @param mbp   Pointer to allocated memory buffer
 * @param sess  SDP Session
 * @param offer True if SDP Offer, False if SDP Answer
 *
 * @return 0 if success, otherwise errorcode
 */
int sdp_encode(struct mbuf **mbp, struct sdp_session *sess, bool offer)

/**
 * Decode an SDP message into an SDP Session
 *
 * @param sess  SDP Session
 * @param mb    Memory buffer containing SDP message
 * @param offer True if SDP offer, False if SDP answer
 *
 * @return 0 if success, otherwise errorcode
 */
int sdp_decode(struct sdp_session *sess, struct mbuf *mb, bool offer)
```

```mermaid
flowchart LR
	subgraph phone[phone]
	end

	subgraph libre[libre]
		sdp_decode
		sdp_encode
	end

	subgraph baresip[baresip]
		subgraph call.c
			sipsess_connect

			sipsess_answer_handler
			send_invite
			sipsess_desc_handler

			call_accept
			call_answer

			send_invite --> sipsess_connect ..-> sipsess_answer_handler
			sipsess_connect ..-> sipsess_desc_handler --> call_sdp_get
		end
	end
	sipsess_answer_handler --> sdp_decode
	call_accept --> sdp_decode
	call_sdp_get --> sdp_encode
	call_answer --> sdp_encode
	
	phone --> |INCOMING|call_accept
	phone -.-o |INCOMING|call_answer
	sipsess_connect --> |OUTGOING|phone
```

# Appendix

# I. Study

# II. Debug

# III. Glossary

# IV. Tool Usage

# Author

>  Created and designed by [Lanka Hsu](lankahsu@gmail.com).

# License

> [HelperX](https://github.com/lankahsu520/HelperX) is available under the BSD-3-Clause license. See the LICENSE file for more info.

