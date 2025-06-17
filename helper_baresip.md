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

> 體會過 baresip 後，覺得在編譯和修改非常容易上手。縱觀其它 sip client(s)，不只編譯困難，引用的 open source 過多過舊，甚至已沒有維護，更重要的就是連怎麼執行都不交待。當然 baresip 在文件交待上也是欠缺，但是程式的布局比較好理解。不過要注意的，Baresip 引用了 [baresip](https://github.com/baresip)/**[re](https://github.com/baresip/re)** 和 [baresip](https://github.com/baresip)/**[rem](https://github.com/baresip/rem)**，有時要 trace code 進到這 2個 libs 或是還要進行修改。
>
> 另外 baresip 用 plugin 的方式載功能，這個讓人很想學習。

```mermaid
flowchart LR
	baresip[baresip]
	linphone[linphone]

	SServers[SIP Servers]

	baresip <--> SServers
	microsip <--> SServers
	linphone <--> SServers
```

# 2. SIP Sequence

## 2.1. REGISTER
```mermaid
sequenceDiagram
	participant phone
	participant server
	participant baresip

	phone->>server: Register
	server->>phone: OK
	baresip->>server: Register
	server->>baresip: OK
```
## 2.2. INCOMING

```mermaid
sequenceDiagram
	participant phone
	participant server
	participant baresip

	phone->>server: INVITE
	server->>phone: Trying
	server->>baresip: INVITE

	baresip->>server: Ringing
	server->>phone: Ringing

	baresip->>server: Answering
	server->>baresip: ACK

	server->>phone: OK
	phone->>server: ACK

```

## 2.3. BYE

```mermaid
sequenceDiagram
	participant phone
	participant server
	participant baresip

	baresip->>server: BYE
	server->>baresip: OK
	server->>phone: BYE
	phone->>server: OK
```

## 2.4. OUTGOING

```mermaid
sequenceDiagram
	participant phone
	participant server
	participant baresip

	baresip->>server: INVITE
	server->>baresip: Trying
	server->>phone: INVITE
	phone->>server: Trying
	phone->>server: Ringing
	server->>baresip: Ringing
	phone->>server: OK
	server->>phone: ACK
	server->>baresip: OK
	baresip->>server: ACK
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

# 5. Trace code

## 5.1. STATE

> github: [baresip](https://github.com/baresip/baresip/tree/main)/[include](https://github.com/baresip/baresip/tree/main/include)/[baresip.h](https://github.com/baresip/baresip/blob/main/include/baresip.h)

```c
/** Call States */
enum call_state {
	CALL_STATE_IDLE = 0,
	CALL_STATE_INCOMING,
	CALL_STATE_OUTGOING,
	CALL_STATE_RINGING,
	CALL_STATE_EARLY,
	CALL_STATE_ESTABLISHED,
	CALL_STATE_TERMINATED,
	CALL_STATE_TRANSFER,
	CALL_STATE_UNKNOWN
};
```

### 5.1.1. CALL_STATE_INCOMING

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

### 5.1.2. CALL_STATE_ESTABLISHED

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

## 5.2. main (usage)

> github: [baresip](https://github.com/baresip/baresip/tree/main)/[src](https://github.com/baresip/baresip/tree/main/src)/[main.c](https://github.com/baresip/baresip/blob/main/src/main.c)

|      | Help             | Variables                        |
| ---- | ---------------- | -------------------------------- |
| -f   | Config path      | conf_path_set(optarg);           |
| -s   | Enable SIP trace | sip_trace = true;<br>sip->traceh |
| -v   | Verbose debug    | log_enable_debug(true);          |

```bash
// baresip/src/main.c
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

## 5.3. struct XXX

### 5.3.1. Linked List (struct list)

> github: [re](https://github.com/baresip/re/tree/main)/[src](https://github.com/baresip/re/tree/main/src)/[list](https://github.com/baresip/re/tree/main/src/list)/[list.c](https://github.com/baresip/re/blob/main/src/list/list.c)
>
> github: [re](https://github.com/baresip/re/tree/main)/[include](https://github.com/baresip/re/tree/main/include)/[re_list.h](https://github.com/baresip/re/blob/main/include/re_list.h)

```c
// re/include/re_list.h
/** Defines a linked list */
struct list {
	struct le *head;  /**< First list element */
	struct le *tail;  /**< Last list element  */
	size_t cnt;       /**< Number of elements */
};
```

### 5.3.2. Interface to memory buffers (struct mbuf)

> github: [re](https://github.com/baresip/re/tree/main)/[include](https://github.com/baresip/re/tree/main/include)/[re_mbuf.h](https://github.com/baresip/re/blob/main/include/re_mbuf.h)

```c
// re/include/re_mbuf.h
/**
 * Defines a memory buffer.
 *
 * This is a dynamic and linear buffer for storing raw bytes.
 * It is designed for network protocols, and supports automatic
 * resizing of the buffer.
 *
 * - Writing to the buffer
 * - Reading from the buffer
 * - Automatic growing of buffer size
 * - Print function for formatting printing
 */
struct mbuf {
	uint8_t *buf;   /**< Buffer memory      */
	size_t size;    /**< Size of buffer     */
	size_t pos;     /**< Position in buffer */
	size_t end;     /**< End of buffer      */
};
```

#### A. Get the buffer from the current position

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

### 5.3.3. SIP Call Control object (struct call)

> github: [baresip](https://github.com/baresip/baresip/tree/main)/[src](https://github.com/baresip/baresip/tree/main/src)/[call.c](https://github.com/baresip/baresip/blob/main/src/call.c)

> call->peer_uri: sip:1007@192.168.50.9

```c
/** SIP Call Control object */
struct call {
	MAGIC_DECL                /**< Magic number for debugging           */
	struct le le;             /**< Linked list element                  */
	const struct config *cfg; /**< Global configuration                 */
	struct ua *ua;            /**< SIP User-agent                       */
	struct account *acc;      /**< Account (ref.)                       */
	struct sipsess *sess;     /**< SIP Session                          */
	struct sdp_session *sdp;  /**< SDP Session                          */
	struct sipsub *sub;       /**< Call transfer REFER subscription     */
	struct sipnot *not;       /**< REFER/NOTIFY client                  */
	struct call *xcall;       /**< Cross ref Transfer call              */
	struct list streaml;      /**< List of mediastreams (struct stream) */
	struct audio *audio;      /**< Audio stream                         */
	struct video *video;      /**< Video stream                         */
	enum call_state state;    /**< Call state                           */
	int32_t adelay;           /**< Auto answer delay in ms              */
	char *aluri;              /**< Alert-Info URI                       */
	char *local_uri;          /**< Local SIP uri                        */
	char *local_name;         /**< Local display name                   */
	char *peer_uri;           /**< Peer SIP Address                     */
	char *peer_name;          /**< Peer display name                    */
	struct sa msg_src;        /**< Peer message source address          */
	char *diverter_uri;       /**< Diverter SIP Address                 */
	char *id;                 /**< Cached session call-id               */
	char *replaces;           /**< Replaces parameter                   */
	uint16_t supported;       /**< Supported header tags                */
	struct tmr tmr_inv;       /**< Timer for incoming calls             */
	struct tmr tmr_dtmf;      /**< Timer for incoming DTMF events       */
	struct tmr tmr_answ;      /**< Timer for delayed answer             */
	struct tmr tmr_reinv;     /**< Timer for outgoing re-INVITES        */
	time_t time_start;        /**< Time when call started               */
	time_t time_conn;         /**< Time when call initiated             */
	time_t time_stop;         /**< Time when call stopped               */
	bool outgoing;            /**< True if outgoing, false if incoming  */
	bool answered;            /**< True if call has been answered       */
	bool got_offer;           /**< Got SDP Offer from Peer              */
	bool on_hold;             /**< True if call is on hold (local)      */
	bool ans_queued;          /**< True if an (auto) answer is queued   */
	struct mnat_sess *mnats;  /**< Media NAT session                    */
	bool mnat_wait;           /**< Waiting for MNAT to establish        */
	struct menc_sess *mencs;  /**< Media encryption session state       */
	int af;                   /**< Preferred Address Family             */
	uint16_t scode;           /**< Termination status code              */
	call_event_h *eh;         /**< Event handler                        */
	call_dtmf_h *dtmfh;       /**< DTMF handler                         */
	void *arg;                /**< Handler argument                     */

	struct config_avt config_avt;    /**< AVT config                    */
	struct config_call config_call;  /**< Call config                   */

	uint32_t rtp_timeout_ms;  /**< RTP Timeout in [ms]                  */
	uint32_t linenum;         /**< Line number from 1 to N              */
	struct list custom_hdrs;  /**< List of custom headers if any        */

	enum sdp_dir estadir;      /**< Established audio direction         */
	enum sdp_dir estvdir;      /**< Established video direction         */
	bool use_video;
	bool use_rtp;
	char *user_data;           /**< User data related to the call       */
	bool evstop;               /**< UA events stopped flag, @deprecated */
};
```

```c
struct call *call = bevent_get_call(event);
```

### 5.3.4. SIP User Agent object (struct ua)

> github: [baresip](https://github.com/baresip/baresip/tree/main)/[src](https://github.com/baresip/baresip/tree/main/src)/[ua.c](https://github.com/baresip/baresip/blob/main/src/ua.c)

```c
/** Defines a SIP User Agent object */
struct ua {
	MAGIC_DECL                   /**< Magic number for struct ua         */
	struct le le;                /**< Linked list element                */
	struct account *acc;         /**< Account Parameters                 */
	struct list regl;            /**< List of Register clients           */
	struct list calls;           /**< List of active calls (struct call) */
	struct pl extensionv[8];     /**< Vector of SIP extensions           */
	size_t    extensionc;        /**< Number of SIP extensions           */
	char *cuser;                 /**< SIP Contact username               */
	char *pub_gruu;              /**< SIP Public GRUU                    */
	enum presence_status pstat;  /**< Presence Status                    */
	struct list hdr_filter;      /**< Filter for incoming headers        */
	struct list custom_hdrs;     /**< List of outgoing headers           */
	char *ansval;                /**< SIP auto answer value              */
	struct sa dst;               /**< Current destination address        */
};
```

```c
struct ua *ua = bevent_get_ua(event);
```

## 5.4. SIP headers

### 5.4.1. custom SIP headers (Send)

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

### 5.4.1. SIP Headers (Receive)

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

## 5.5. SDP

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

# 6. modules

> baresip 使用 plugin 的方式相當的淋漓盡致，這部分還有待學習。

## 6.0. module_init

> 讀取 config 中的 module ???.so/module_app ???.so（例 stdio.so），使用 dlopen 載入該函式庫，再用 dlsym 獲得  const struct mod_export DECL_EXPORTS(XXX) 的 "export" 位置。然後執行 m->me->init()。

```mermaid
flowchart LR
	subgraph main.c[main.c]
		main
	end
	subgraph conf.c[conf.c]
		conf_modules
	end
	subgraph module.c[module.c]
		module_init
		module_handler
		module_app_handler
		
		load_module
		
		module_init --> |1|module_handler --> load_module
		module_init --> |2|module_app_handler --> load_module
	end

	subgraph mod.c[mod.c]
		mod_load
	end
	
	subgraph dl.c[dl.c]
		_mod_open
		_mod_sym
	end
	
	main --> conf_modules --> module_init
	load_module --> mod_load --> _mod_open --> dlopen
	mod_load --> |export|_mod_sym --> dlsym
```

```c
// baresip/src/module.c
int module_init(const struct conf *conf)
{
	...
	err = conf_apply(conf, "module", module_handler, &path);
	...
	err = conf_apply(conf, "module_app", module_app_handler, &path);
	...
}
```

## 6.1. stdio.so

> 從 STDIN_FILENO 等待按鍵按下；當按鍵觸發後的流程，大致如下。另外常用傳送命令的 cons.so (Console input driver) 和 ctrl_dbus.so (DBus control interface)

> 這邊要注意 stdio 和 cons 有處理 KEYCODE_REL

```config
module                        stdio.so
```

> User-Interface (UI) module

```mermaid
flowchart LR
	subgraph cmd.c[cmd.c]
		cmd_process
		cmd_process_long
	end

	subgraph ui.c[ui.c]
		ui_input_key
		ui_input_long_command
		ui_input_str
		ui_input_pl
		
		ui_input_str --> ui_input_pl
	end
	ui_input_key --> cmd_process
	ui_input_long_command --> cmd_process_long
	ui_input_pl --> cmd_process

	subgraph main.c[main.c]
		main
	end
	main --> ui_input_str
  
	subgraph stdio.c[stdio.c]
		ui_fd_handler
		report_key
		stdio-timeout[timeout]
		
		ui_fd_handler-->report_key
		ui_fd_handler ..-> |250ms, KEYCODE_REL|stdio-timeout --> report_key
	end
	STDIN_FILENO ..-> ui_fd_handler
	report_key --> ui_input_key

	subgraph cons.c[cons.c]
		udp_recv
		tcp_recv_handler
		cons-timeout[timeout]
	end
	udp_recv --> ui_input_key
	tcp_recv_handler --> ui_input_key
	cons-timeout --> ui_input_key

	subgraph ctrl_dbus.c[ctrl_dbus.c]
		command_handler
	end
	command_handler --> cmd_process
	command_handler --> cmd_process_long

	subgraph httpd.c[httpd.c]
		handle_input
	end
	handle_input --> ui_input_long_command
	handle_input --> ui_input_pl	
```

```c
// baresip/include/baresip.h
/* special keys */
#define KEYCODE_NONE   (0x00)    /* No key           */
#define KEYCODE_REL    (0x04)    /* Key was released */
#define KEYCODE_ESC    (0x1b)    /* Escape key       */

// baresip/modules/cons/cons.c
static void udp_recv(const struct sa *src, struct mbuf *mb, void *arg)
{
	...
		ui_input_key(baresip_uis(), ch, &pf);
	...
}

// baresip/modules/cons/cons.c
static void tcp_recv_handler(struct mbuf *mb, void *arg)
{
	...
		ui_input_key(baresip_uis(), ch, &pf);
	...
}

// baresip/src/ui.c
/**
 * Send an input key to the UI subsystem, with a print function for response
 *
 * @param uis UI Subsystem
 * @param key Input character
 * @param pf  Print function for the response
 */
void ui_input_key(struct ui_sub *uis, char key, struct re_printf *pf)
{
	if (!uis)
		return;

	(void)cmd_process(baresip_commands(), &uis->uictx, key, pf, NULL);
}

```

## 6.2. menu.so

```config
module_app                    menu.so
```

### 6.2.1. dial_menu

```c
// baresip/modules/menu/static_menu.c
static const struct cmd cmdv[] = {
	...
}
```

#### A. CALL_STATE_IDLE

```bash
--- Help ---
                      ESC      Hangup call
  /100rel ..                   Set 100rel mode
  /about                       About box
  /accept             a        Accept incoming call
  /acceptdir ..                Accept incoming call with audio and videodirection.
  /addcontact ..               Add a contact
  /answermode ..               Set answer mode
  /apistate                    User Agent state
  /aufileinfo ..               Audio file info
  /auplay ..                   Switch audio player
  /ausrc ..                    Switch audio source
  /callstat           c        Call status
  /conf_reload                 Reload config file
  /config                      Print configuration
  /contact_next       >        Set next contact
  /contact_prev       <        Set previous contact
  /contacts           C        List contacts
  /dial ..            d ..     Dial
  /dialcontact        D        Dial current contact
  /dialdir ..                  Dial with audio and videodirection.
  /dnd ..                      Set Do not Disturb
  /entransp ..                 Enable/Disable transport
  /hangup             b        Hangup call
  /hangupall ..                Hangup all calls with direction
  /help               h        Help menu
  /insmod ..                   Load module
  /listcalls          l        List active calls
  /loglevel           v        Log level toggle
  /main                        Main loop debug
  /memstat            y        Memory status
  /message ..         M ..     Message current contact
  /modules                     Module debug
  /netstat            n        Network debug
  /options ..         o ..     Options
  /play ..                     Play audio file
  /quit               q        Quit
  /refer ..           R ..     Send REFER outside dialog
  /reginfo            r        Registration info
  /rmcontact ..                Remove a contact
  /rmmod ..                    Unload module
  /setadelay ..                Set answer delay for outgoing call
  /setansval ..                Set value for Call-Info/Alert-Info
  /sipstat            i        SIP debug
  /sysinfo            s        System info
  /timers                      Timer debug
  /tlsissuer                   TLS certificate issuer
  /tlssubject                  TLS certificate subject
  /uaaddheader ..              Add custom header to UA
  /uadel ..                    Delete User-Agent
  /uadelall ..                 Delete all User-Agents
  /uafind ..                   Find User-Agent <aor>
  /uanew ..                    Create User-Agent
  /uareg ..                    UA register <regint> [index]
  /uarmheader ..               Remove custom header from UA
  /uastat             u        UA debug
  /uuid                        Print UUID
  /vidsrc ..                   Switch video source
```

#### B. CALL_STATE_INCOMING

```bash
--- Help ---
                        ESC      Hangup call
  /100rel ..                     Set 100rel mode
  /about                         About box
  /accept               a        Accept incoming call
  /acceptdir ..                  Accept incoming call with audio and videodirection.
  /addcontact ..                 Add a contact
  /answermode ..                 Set answer mode
  /apistate                      User Agent state
  /atransferabort                Abort attended transfer
  /atransferexec                 Execute attended transfer
  /atransferstart ..    T ..     Start attended transfer
  /aubitrate ..                  Set audio bitrate
  /audio_debug          A        Audio stream
  /aufileinfo ..                 Audio file info
  /auplay ..                     Switch audio player
  /ausrc ..                      Switch audio source
  /callfind ..                   Find call <callid>
  /callstat             c        Call status
  /conf_reload                   Reload config file
  /config                        Print configuration
  /contact_next         >        Set next contact
  /contact_prev         <        Set previous contact
  /contacts             C        List contacts
  /dial ..              d ..     Dial
  /dialcontact          D        Dial current contact
  /dialdir ..                    Dial with audio and videodirection.
  /dnd ..                        Set Do not Disturb
  /entransp ..                   Enable/Disable transport
  /hangup               b        Hangup call
  /hangupall ..                  Hangup all calls with direction
  /help                 h        Help menu
  /hold                 x        Call hold
  /insmod ..                     Load module
  /line ..              @ ..     Set current call <line>
  /listcalls            l        List active calls
  /loglevel             v        Log level toggle
  /main                          Main loop debug
  /medialdir ..                  Set local media direction
  /memstat              y        Memory status
  /message ..           M ..     Message current contact
  /modules                       Module debug
  /mute ..              m ..     Call mute/un-mute
  /netstat              n        Network debug
  /options ..           o ..     Options
  /play ..                       Play audio file
  /quit                 q        Quit
  /refer ..             R ..     Send REFER outside dialog
  /reginfo              r        Registration info
  /reinvite             I        Send re-INVITE
  /resume               X        Call resume
  /rmcontact ..                  Remove a contact
  /rmmod ..                      Unload module
  /setadelay ..                  Set answer delay for outgoing call
  /setansval ..                  Set value for Call-Info/Alert-Info
  /sipstat              i        SIP debug
  /sndcode ..                    Send Code
  /statmode             S        Statusmode toggle
  /stopringing                   Stop ring tones
  /sysinfo              s        System info
  /timers                        Timer debug
  /tlsissuer                     TLS certificate issuer
  /tlssubject                    TLS certificate subject
  /transfer ..          t ..     Transfer call
  /uaaddheader ..                Add custom header to UA
  /uadel ..                      Delete User-Agent
  /uadelall ..                   Delete all User-Agents
  /uafind ..                     Find User-Agent <aor>
  /uanew ..                      Create User-Agent
  /uareg ..                      UA register <regint> [index]
  /uarmheader ..                 Remove custom header from UA
  /uastat               u        UA debug
  /uuid                          Print UUID
  /video_debug          V        Video stream
  /videodir ..                   Set video direction
  /vidsrc ..                     Switch video source
```

## 6.3. ctrl_dbus.so

> 會自動產生
> build_xxx/modules/ctrl_dbus/baresipbus.c
> build_xxx/modules/ctrl_dbus/baresipbus.h

```config
module_app                    ctrl_dbus.so
```
### 6.3.1. method - invoke

| name     | direction | type |
| -------- | --------- | ---- |
| command  | in        | s    |
| response | out       | s    |

```mermaid
flowchart LR
	dbus([dbus])

	subgraph baresip
		subgraph ctrl_dbus.c[ctrl_dbus.c]
			on_handle_invoke[on_handle_invoke]
			mqueue_push[mqueue_push]
			
			queue_handler[queue_handler]
			command_handler[command_handler]

			on_handle_invoke --> mqueue_push ..-> queue_handler --> command_handler
		end
	end

	dbus <--> on_handle_invoke
```

```bash
"a": 
```



### 6.3.2. event (signal)

> dbus_id 是另外加上去的，用於設計能在同一台主機上連上多個 SIP。

| name    | direction | type |
| ------- | --------- | ---- |
| class   | out       | s    |
| evtype  | out       | s    |
| param   | out       | s    |
| dbus_id | out       | u    |

#### A. Register

> call bevent_register 來註冊 incoming SIP Requests

```mermaid
flowchart TB
	subgraph baresip
		subgraph ctrl_dbus.c[ctrl_dbus.c]
			ctrl_init[ctrl_init]
		end
		subgraph bevent.c[bevent.c]
			bevent_register[bevent_register]
		end
		
		ctrl_init --> bevent_register
	end
```


```c
// baresip/modules/ctrl_dbus/ctrl_dbus.c
static int ctrl_init(void)
{
	...
	err = bevent_register(event_handler, m_st);
	...
}

// baresip/bevent.c
/**
 * Register an Event handler
 *
 * @param eh  Event handler
 * @param arg Handler argument
 *
 * @return 0 if success, otherwise errorcode
 */
int  bevent_register(bevent_h *eh, void *arg)
```

#### B. Event
```mermaid
flowchart LR
	dbus([dbus])

	subgraph baresip
		subgraph ctrl_dbus.c[ctrl_dbus.c]
			event_handler[event_handler]
			dbus_baresip_emit_event[dbus_baresip_emit_event]
			
			event_handler ..-> dbus_baresip_emit_event
		end
		
		subgraph bevent.c[bevent.c]
			ua_event[ua_event]
			module_event[module_event]
			
			subgraph bevent_emit_base[bevent_emit_base]
				h[h]
			end
			
			bevent_emit[bevent_emit]
	
			bevent_app_emit[bevent_app_emit]
			bevent_ua_emit[bevent_ua_emit]
			bevent_call_emit[bevent_call_emit]
			bevent_sip_msg_emit[bevent_sip_msg_emit]

			module_event ..-> bevent_emit_base
			bevent_app_emit ..-> bevent_emit
			bevent_ua_emit ..-> bevent_emit
			bevent_call_emit ..-> bevent_emit
			bevent_sip_msg_emit ..-> bevent_emit
			
			bevent_emit ..-> bevent_emit_base
		end
		
		h ..-> event_handler
	end
	
	dbus_baresip_emit_event ..-> dbus
```

```c
// baresip/bevent.c
static void bevent_emit_base(struct bevent *event)
{
	...
			ehe->h(event->ev, event, ehe->arg);
	...
}

static int bevent_emit(struct bevent *event, const char *fmt, va_list ap)
{
	...
	bevent_emit_base(event);
	...
}

/**
 * Emit an application event
 *
 * @param ev   User-agent event
 * @param arg  Application specific argument (optional)
 * @param fmt  Formatted arguments
 * @param ...  Variable arguments
 *
 * @return 0 if success, otherwise errorcode
 */
int bevent_app_emit(enum ua_event ev, void *arg, const char *fmt, ...)
{
	...
	err = bevent_emit(&event, fmt, ap);
	...
}

/**
 * Emit a User-Agent event
 *
 * @param ev   User-Agent event
 * @param ua   User-Agent
 * @param fmt  Formatted arguments
 * @param ...  Variable arguments
 *
 * @return 0 if success, otherwise errorcode
 */
int bevent_ua_emit(enum ua_event ev, struct ua *ua, const char *fmt, ...)
{
	...
	err = bevent_emit(&event, fmt, ap);
	...
}

/**
 * Emit a Call event
 *
 * @param ev    User-Agent event
 * @param call  Call object
 * @param fmt   Formatted arguments
 * @param ...   Variable arguments
 *
 * @return 0 if success, otherwise errorcode
 */
int bevent_call_emit(enum ua_event ev, struct call *call, const char *fmt, ...)
{
	...
	err = bevent_emit(&event, fmt, ap);
	...
}

/**
 * Emit a SIP message event
 *
 * @param ev    User-Agent event
 * @param msg   SIP message
 * @param fmt   Formatted arguments
 * @param ...   Variable arguments
 *
 * @return 0 if success, otherwise errorcode
 */
int bevent_sip_msg_emit(enum ua_event ev, const struct sip_msg *msg,
		       const char *fmt, ...)
{
	...
	err = bevent_emit(&event, fmt, ap);
	...
}
```

#### C. log

```log
e_class: call, e_evtype: CALL_REMOTE_SDP, e_param: {"class":"call","type":"CALL_REMOTE_SDP","accountaor":"sip:1004@192.168.50.9","direction":"incoming","peeruri":"sip:1007@192.168.50.9","localuri":"sip:1004-0x56046c6cd9b0@192.168.50.72","remoteaudiodir":"sendrecv","remotevideodir":"sendrecv","audiodir":"sendrecv","videodir":"sendrecv","localaudiodir":"sendrecv","localvideodir":"sendrecv","param":"offer"}, e_dbus_id: 1

e_class: call, e_evtype: CALL_INCOMING, e_param: {"class":"call","type":"CALL_INCOMING","accountaor":"sip:1004@192.168.50.9","direction":"incoming","peeruri":"sip:1007@192.168.50.9","localuri":"sip:1004-0x56046c6cd9b0@192.168.50.72","id":"1658f6cc-de2e-4487-afeb-44f315cee6d4","remoteaudiodir":"sendrecv","remotevideodir":"sendrecv","audiodir":"sendrecv","videodir":"sendrecv","localaudiodir":"sendrecv","localvideodir":"sendrecv","param":"sip:1007@192.168.50.9"}, e_dbus_id: 1


e_class: call, e_evtype: CALL_CLOSED, e_param: {"class":"call","type":"CALL_CLOSED","accountaor":"sip:1004@192.168.50.9","direction":"incoming","peeruri":"sip:1007@192.168.50.9","localuri":"sip:1004-0x56046c6cd9b0@192.168.50.72","id":"1658f6cc-de2e-4487-afeb-44f315cee6d4","remoteaudiodir":"sendrecv","remotevideodir":"sendrecv","audiodir":"sendrecv","videodir":"sendrecv","localaudiodir":"sendrecv","localvideodir":"sendrecv","param":"Rejected by user"}, e_dbus_id: 1
```

### 6.3.3. message (signal)

> dbus_id 是另外加上去的，用於設計能在同一台主機上連上多個 SIP。

| name    | direction | type |
| ------- | --------- | ---- |
| ua      | out       | s    |
| peer    | out       | s    |
| ctype   | out       | s    |
| body    | out       | s    |
| dbus_id | out       | u    |

#### A. Register

> call message_listen 來註冊 incoming SIP Requests
```mermaid
flowchart LR
	subgraph re
		subgraph sip[sip.c]
			sip_listen[sip_listen]
		end
	end

	subgraph baresip
		subgraph ctrl_dbus.c[ctrl_dbus.c]
			ctrl_init[ctrl_init]
		end
		subgraph message.c[message.c]
			message_listen[message_listen]
		end
		
		ctrl_init --> message_listen
	end

	message_listen --> sip_listen
```


```c
// baresip/modules/ctrl_dbus/ctrl_dbus.c
static int ctrl_init(void)
{
	...
	err = message_listen(baresip_message(), message_handler, m_st);
	...
}

// baresip/src/message.c
/**
 * Listen to incoming SIP MESSAGE messages
 *
 * @param message Messaging subsystem
 * @param recvh   Message receive handler
 * @param arg     Handler argument
 *
 * @return 0 if success, otherwise errorcode
 */
int message_listen(struct message *message,
		   message_recv_h *recvh, void *arg)
{
	...
		err = sip_listen(&message->sip_lsnr, uag_sip(), true,
				 request_handler, message);
	...
}
```

```c
// re/src/sip/sip.c
/**
 * Listen for incoming SIP Requests and SIP Responses
 *
 * @param lsnrp Pointer to allocated listener
 * @param sip   SIP stack instance
 * @param req   True for Request, false for Response
 * @param msgh  SIP message handler
 * @param arg   Handler argument
 *
 * @return 0 if success, otherwise errorcode
 */
int sip_listen(struct sip_lsnr **lsnrp, struct sip *sip, bool req,
	       sip_msg_h *msgh, void *arg)
{
	...
	lsnr->msgh = msgh;
	...
}
```

#### B. Request

> 雖然註冊接收 incoming SIP Requests，但是排第5順位，在  sip_recv  中如果前面已經處理 ( return TRUE )，基本上是不會到 message。
>
> 所以這個程式是做白工。

```mermaid
flowchart LR
	subgraph re
		subgraph transp.c[transp.c]
			udp_recv_handler
			tcp_recv_handler
			subgraph sip_recv
				msgh
			end

			udp_recv_handler --> sip_recv
			tcp_recv_handler --> sip_recv
		end

		subgraph strans.c[strans.c]
			stransR[request_handler]
		end

		subgraph sipeventlisten[sipevent/listen.c]
			sipeventlistenR[response_handler]
		end

		subgraph sipsesslisten[sipsess/listen.c]
			sipsesslistenR[response_handler]
		end
	end

	subgraph ctrans.c[ctrans.c]
		ctransR[response_handler]
	end

	subgraph baresip
		subgraph uag.c[uag.c]
			uagR[response_handler]
		end
		subgraph message.c[message.c]
			messageR[request_handler]
			subgraph handle_message[handle_message]
				recvh[recvh]
			end
			messageR ..-> handle_message
		end

		subgraph ctrl_dbus.c[ctrl_dbus.c]
			ctrl_dbusR[message_handler]
		end
		subgraph ctrl_tcp.c[ctrl_tcp.c]
			ctrl_tcpR[message_handler]
		end
		subgraph gtk_mod.c[gtk_mod.c]
			gtk_modR[message_handler]
		end
		subgraph menu.c[menu.c]
			menuR[message_handler]
		end
		recvh ..->  ctrl_dbusR
		recvh ..->  ctrl_tcpR
		recvh ..->  gtk_modR
		recvh ..->  menuR
  end

	msgh -..-> ctransR

	msgh -..-> |1| stransR
	msgh -..-> |2| uagR
	msgh -..-> |3| sipsesslistenR
	msgh -..-> |4| sipeventlistenR
	msgh -..-> |5| messageR
```
```c
// re/src/sip/transp.c
static void sip_recv(struct sip *sip, const struct sip_msg *msg,
		     size_t start)
{
	...
		if (lsnr->msgh(msg, lsnr->arg))
		{
			return;
		}
	...
}
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

